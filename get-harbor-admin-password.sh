#!/bin/bash

if ! command -v jq >/dev/null 2>&1 ; then
  echo "JQ not installed. Exiting...."
  exit 1
fi

export VDS=`kubectl get deploy -n vmware-system-lbapi vmware-system-lbapi-lbapi-controller-manager --no-headers 2>/dev/null |wc -l`
if [ ${VDS} -eq 0 ]
then
  harborinstalled=`kubectl get ns|grep -c vmware-system-registry-`
  if [ ${harborinstalled} -eq 1 ]
  then
    harborns=`kubectl get ns -o json|jq -r '.items[] | select(.metadata.name | contains ("vmware-system-registry-"))'.metadata.name`
    harborid=`echo ${harborid}|cut -d- -f4
    kubectl get secrets -n ${harborns} harbor-${harborid}-controller-registry -o json|jq -r '.data.harborAdminPassword'|base64 -d|base64 -d;echo
  else
     echo "vSphere Registry service not enabled. Please enable and then re-run the script"
     exit 1
else
  echo "Found VDS based setup. Integrated Harbor registry is not supported."
  exit 1
fi
