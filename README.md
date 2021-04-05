# tkg-helper-scripts

1. `exec-on-tkgs-nodes.sh` - Script to execute a command on all the nodes of a TKGs cluster. Make sure you run this script in the Supervior Cluster context. Pass command line arguments as per your requirements

```shell
./exec-on-tkgs-nodes.sh -n [Namespace within the Supervisor Cluster, where the TKGs cluster resides] -t [Name of the TKGs cluster] -c [Command to execute, use ' or " to input multiple strings as command] 
#
./execontkgs.sh -n demo1 -t workload-vsphere-tkg1 -c 'sudo cat /etc/kubernetes/extra-config/audit-policy.yaml'
```


Note:- After the initial run, it may take a *couple fo runs* for the script to succseefully execute commands, as the jumpbox gets ready. Also, During the initial runs, you may have to enter *Yes* to accept the SSH thumbprint of the nodes.

2. `create-wcp-privuser.sh` - GOVC script to create a user with permissions to modify objects in the VCenter for WCP protected objects. 
