# Highly experimantal. Not for production use. Can cause issues !!!!
# Modify the two variables. 
export WCP_USER=wcpadmin
export PASSWORD=VMware1!

govc sso.user.create -p ${PASSWORD} -R Admin ${WCP_USER}
govc sso.group.update -a=${WCP_USER} ServiceProviderUsers

#The below line may not work. In this case, modify the global permission to add the user with admin role, propagate enabled. 
govc permissions.set -principal="${WCP_USER}@VSPHERE.LOCAL" -propagate=true -role=Admin /

# govc tags.category.create iscsi-category
# govc tags.create -c iscsi-category iscsi
# govc tags.attach iscsi /RegionA01/datastore/RegionA01-ISCSI02-COMP01
