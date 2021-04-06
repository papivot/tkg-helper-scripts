# vSphere with Tanzu Helper scripts

In this repository, you will find a collection of helpful scripts that users can use to troubleshoot and/or interact with vSphere with Tanzu. 

---
1. `exec-on-tkgs-nodes.sh` - Script to execute a command on all the nodes of a Tanzu Kubernetes cluster on vSphere 7. Make sure you run this script in the **Supervisor Cluster context**. Pass command-line arguments as per your requirements  

```shell
$ ./exec-on-tkgs-nodes.sh -n [Namespace within the Supervisor Cluster, where the TKGs cluster resides] -t [Name of the TKGs cluster] -c [Command to execute, use ' or " to input multiple strings as command] 
# For example - 
$ ./exec-on-tkgs-nodes.sh -n demo1 -t workload-vsphere-tkg1 -c 'sudo cat /etc/kubernetes/extra-config/audit-policy.yaml'
```

Note:- At the initial run, it may take a *couple of minutes* for the script to execute commands as the jump box gets ready successfully. Also, During the initial runs, you may have to enter *Yes* to accept the nodes' SSH thumbprint.

---
2. `download-images-offline-tkr.sh` - This is a handy script to download Tanzu Kunbernetes Releases(TKR) OVA images from the VMware Subscribed content library. This is particularly helpful when the vCenter is in a firewalled environment, and the Kubernetes content library needs to be populated with the TKR images. This script downloads and zips the ova files to be easily transported to the offline environment for easy upload to the content library.   

```shell
$ ./download-images-offline-tkr.sh

The VMware subscribed content library has the following Tanzu Kubernetes Release images ...

ob-17332787-photon-3-k8s-v1.17.13---vmware.1-tkg.2.2c133ed
ob-17654937-photon-3-k8s-v1.18.15---vmware.1-tkg.1.600e412
ob-17010758-photon-3-k8s-v1.17.11---vmware.1-tkg.2.ad3d374
ob-17419070-photon-3-k8s-v1.18.10---vmware.1-tkg.1.3a6cd48
ob-17660956-photon-3-k8s-v1.19.7---vmware.1-tkg.1.fc82c41
ob-16924027-photon-3-k8s-v1.17.11---vmware.1-tkg.1.15f1e18
...

Enter the name of the TanzuKubernetesRelease OVA that you want to download and zip for offline upload: ob-16924027-photon-3-k8s-v1.17.11---vmware.1-tkg.1.15f1e18
...
```

---
3. `get-harbor-admin-password.sh` - The Harbor registry delivered through vSphere with Tanzu is heavily locked down, and the admin credentials are a bit difficult to extract. This script helps to get the required credentials. Due to current limitations, the Harbor namespace is locked down, and this script needs to be executed from the WCP Supervisor control plane VM(s).

WARNING - THIS IS USED FOR ADVANCED TROUBLESHOOTING AND SHOULD NOT BE USED FOR NORMAL OPERATIONS. 

---
4. `create-wcp-privuser.sh` - GOVC script to create a user with permissions to modify objects in the VCenter for WCP protected objects. 
