#!/bin/bash

while getopts ":n:t:c:" flag
do
    case ${flag} in
        n ) NAMESPACE=${OPTARG}
	    ;;
        t ) TKGSCLUSTER=${OPTARG}
	    ;;
        c ) COMMAND=${OPTARG}
	    ;;
    esac
done

if ! command -v jq >/dev/null 2>&1 ; then
  echo "JQ not installed. Exiting...."
  exit 1
fi

echo
echo "Executing $COMMAND on the nodes of $TKGSCLUSTER cluster within the $NAMESPACE namespace..."
echo

##################################

export VDS=`kubectl get deploy -n vmware-system-lbapi vmware-system-lbapi-lbapi-controller-manager --no-headers 2>/dev/null |wc -l`
if [ ${VDS} -eq 0 ]
then
  echo "Found NSX based setup. Installing jumpbox pod in $NAMESPACE namespace within Supervisor cluster..."
  export FILE=jumpboxpod-sample.yml
  cat <<EOM > ${FILE}
---
apiVersion: v1
kind: Pod
metadata:
  name: jumpbox
  namespace: ${NAMESPACE}
spec:
  containers:
  - image: "ubuntu:20.04"
    name: jumpbox
    command: ["/bin/bash"] # Fix this
    args: [ "-c", "apt-get -y update; apt-get -y install openssh-client; mkdir /root/.ssh; cp /root/ssh/ssh-privatekey /root/.ssh/id_rsa; chmod 600 /root/.ssh/id_rsa; while true; do sleep 30; done;" ]
    volumeMounts:
      - mountPath: "/root/ssh"
        name: ssh-key
        readOnly: true
  volumes:
    - name: ssh-key
      secret:
        secretName: ${TKGSCLUSTER}-ssh
EOM

  envsubst < ${FILE}|kubectl apply -f-
  kubectl wait --for=condition=Ready -n ${NAMESPACE} pod/jumpbox
  echo "Waiting for jumpbox to be ready..."
  sleep 60s
fi

for node in `kubectl get tkc ${TKGSCLUSTER}  -n ${NAMESPACE} -o json|jq -r '.status.nodeStatus| keys[]'`
do
  ip=`kubectl get virtualmachines -n ${NAMESPACE} ${node} -o json|jq -r '.status.vmIp'`
  echo "==========================================================================="
  echo "Executing command - ${COMMAND} - on ${ip}..."
  echo "==========================================================================="
  echo
  if [ ${VDS} -eq 0 ]
  then
        kubectl -n ${NAMESPACE} exec -it jumpbox -- /usr/bin/ssh -o StrictHostKeyChecking=no vmware-system-user@$ip ${COMMAND}
  else
        kubectl get secret -n ${NAMESPACE} ${TKGSCLUSTER}-ssh -o json |jq -r '.data."ssh-privatekey"'|base64 -d > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        ssh -o StrictHostKeyChecking=no vmware-system-user@${ip} ${COMMAND}
  fi
done

if [ ${VDS} -eq 0 ]
then
  kubectl delete pod jumpbox -n ${NAMESPACE}
  rm ${FILE}
fi
