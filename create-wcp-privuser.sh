#!/bin/bash

# Highly experimantal. Not for production use. Can cause issues !!!!
# Modify the two variables. 

if ! command -v govc >/dev/null 2>&1 ; then
  echo "govc not installed. Exiting...."
  exit 1
fi

export GOVC_URL=myvcenter.vmware.local
export GOVC_USERNAME=administrator@vsphere.local
export GOVC_PASSWORD=myvcenterpassword
export GOVC_INSECURE=true

export WCP_USER=wcpadmin
export PASSWORD=VMware1!

# Create a user with Admin Privilages and set appropriate permissions
govc sso.user.create -p ${PASSWORD} -R Admin ${WCP_USER}
govc permissions.set -principal="${WCP_USER}@VSPHERE.LOCAL" -propagate=true -role=Admin /
govc sso.group.update -a=${WCP_USER} ServiceProviderUsers
