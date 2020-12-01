govc sso.user.create -p VMware1! -R Admin wcp-user1
govc sso.group.update -a=wcp-user1 ServiceProviderUsers
govc permissions.set -principal='wcp-user1@VSPHERE.LOCAL' -propagate=true -role=Admin /
