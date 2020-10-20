# Change these as per requirement
# The script needs to run under the context of the supervisor cluster
# Pre-req jq, kubectl
export NAMESPACE=demo1
export TKGSCLUSTER=workload-vsphere-tkg1
export COMMAND="sudo tdnf install -y linux-esx-devel-4.19.129-1.ph3"

##################################
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
  - image: "photon:3.0"
    name: jumpbox
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "yum install -y openssh-server; mkdir /root/.ssh; cp /root/ssh/ssh-privatekey /root/.ssh/id_rsa; chmod 600 /root/.ssh/id_rsa; while true; do sleep 30; done;" ]
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
for node in `kubectl get tkc ${TKGSCLUSTER}  -n ${NAMESPACE} -o json|jq -r '.status.nodeStatus| keys[]'`
do
  ip=`kubectl get virtualmachines -n ${NAMESPACE} ${node} -o json|jq -r '.status.vmIp'`
  echo "==========================================================================="
  echo "Executing command - ${COMMAND} - on ${ip}..."
  echo "==========================================================================="
  echo
  kubectl -n ${NAMESPACE} exec -it jumpbox -- /usr/bin/ssh vmware-system-user@$ip ${COMMAND}
done

#kubectl delete pod jumpbox -n ${NAMESPACE}
rm ${FILE}
