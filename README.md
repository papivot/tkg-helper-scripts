# tkg-helper-scripts

1. `exec-on-tkgs-nodes.sh` - Script to execute a command on all the nodes of a TKGs cluster. Make sure you run this script in the Supervior Cluster context. Modify the 3 values in the script based on your requirements. 
```
export NAMESPACE=Namespace within the Supervisor Cluster, where the TKGs cluster resides
export TKGSCLUSTER=Name of the TKGs cluster
export COMMAND="Command to execute"
```

Note:- After the initial run, it may take a *couple fo runs* for the script to succseefully execute commands, as the jumpbox gets ready. Also, During the initial runs, you may have to enter *Yes* to accept the SSH thumbprint of the nodes.
