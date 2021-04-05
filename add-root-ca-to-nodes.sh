#!/bin/bash
##############################################################################################################
##############################################################################################################
################# DO NOT USE THIS FILE 
##############################################################################################################
##############################################################################################################

# path of the manually downloaded harbor/registry root CA
rootCA="/tmp/rootca.crt"

# guest cluster name
gcname="workload-vsphere-tkg1"

# Supervisor cluster namespace where guest cluster get deployed
gcnamespace="demo1"

# ===============================================================================
# Do not modify below this line
#

[ -z "$rootCA" -o -z "$gcname" -o -z "$gcnamespace" ] && echo "Please populate rootCA/gcname/gcnamespace variable" && exit
workdir="/tmp/$gcnamespace-$gcname"
mkdir -p $workdir
sshkey=$workdir/gc-sshkey # path for gc private key

# path for gc kubeconfig
gckubeconfig=$workdir/kubeconfig

# @param1: ip
# @param2: ca
installCA() 
{
	node_ip=$1
	capath=$2
	scp -q -i $sshkey -o StrictHostKeyChecking=no $capath vmware-system-user@$node_ip:/tmp/ca.new_bk
	[ $? == 0 ] && ssh -q -i $sshkey -o StrictHostKeyChecking=no vmware-system-user@$node_ip 'sudo cp /etc/pki/tls/certs/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt_bk'
	[ $? == 0 ] && ssh -q -i $sshkey -o StrictHostKeyChecking=no vmware-system-user@$node_ip 'sudo cp /etc/pki/tls/certs/ca-bundle.crt /tmp/ca-bundle.crt_bk'
	[ $? == 0 ] && ssh -q -i $sshkey -o StrictHostKeyChecking=no vmware-system-user@$node_ip 'sudo cat /tmp/ca-bundle.crt_bk /tmp/ca.new_bk > /tmp/ca-bundle.crt'
	[ $? == 0 ] && ssh -q -i $sshkey -o StrictHostKeyChecking=no vmware-system-user@$node_ip 'sudo mv /tmp/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt'
	[ $? == 0 ] && ssh -q -i $sshkey -o StrictHostKeyChecking=no vmware-system-user@$node_ip 'sudo chmod 755 /etc/pki/tls/certs/ca-bundle.crt'
	[ $? == 0 ] && ssh -q -i $sshkey -o StrictHostKeyChecking=no vmware-system-user@$node_ip 'sudo chown root:root /etc/pki/tls/certs/ca-bundle.crt'
#	[ $? == 0 ] && ssh -q -i $sshkey -o StrictHostKeyChecking=no vmware-system-user@$node_ip 'ls -al /tmp/ca*'
#	[ $? == 0 ] && ssh -q -i $sshkey -o StrictHostKeyChecking=no vmware-system-user@$node_ip 'ls -al /etc/pki/tls/certs/'
	# if error occurred, restore ca-bundler.crt_bk
	[ $? == 0 ] && ssh -q -i $sshkey -o StrictHostKeyChecking=no vmware-system-user@$node_ip sudo systemctl restart docker.service
}


# get guest cluster private key for each node
kubectl get secret -n $gcnamespace $gcname"-ssh" -o jsonpath='{.data.ssh-privatekey}' | base64 --decode > $sshkey
[ $? != 0 ] && echo " please check existence of guest cluster private key secret" && exit
chmod 600 $sshkey

#get guest cluster kubeconfig
kubectl get secret -n $gcnamespace $gcname"-kubeconfig" -o jsonpath='{.data.value}' | base64 --decode > $gckubeconfig
[ $? != 0 ] && echo " please check existence of guest cluster private key secret" && exit

# get IPs of each guest cluster nodes
iplist=$(KUBECONFIG=$gckubeconfig kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')
for ip in $iplist
do
	echo "installing root ca into node $ip (needs about 10 seconds)... "
	installCA $ip $rootCA && echo "Successfully installed root ca into node $ip" || echo "Failed to install root ca into node $ip"
done
