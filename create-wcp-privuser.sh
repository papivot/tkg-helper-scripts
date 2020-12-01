# Highly experimantal. Not for production use. Can cause issues !!!!
# Modify the two variables. 
export WCP_USER=wcp-user1
export PASSWORD=VMware1!

govc sso.user.create -p ${PASSWORD} -R Admin ${WCP_USER}
govc sso.group.update -a=${WCP_USER} ServiceProviderUsers

#The below line may not work. In this case, modify the global permission to add the user with admin role, propagate enabled. 
govc permissions.set -principal="${WCP_USER}@VSPHERE.LOCAL" -propagate=true -role=Admin /
