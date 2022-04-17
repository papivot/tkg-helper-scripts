Follow the below guidelines to deploy applications and daemonsets to a Supervisor Cluster running on VDS based networking. 

* Note - Since the VDS based Supervisor Clusters do not have any CNI running on them and are locked down due to security requreiments, certain changes are needed to bypass these limitations. Also, IPTABLES enforce firewall restrictions on the nodes, so exposing services through loadbalancers would be a limitation. 

### Step 1. (Optional) Preferebly create a new namespace
```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: velero
  labels:
    component: minio
```

### Step 2. (Optional) Create new service account and add allow wcp-privilaged-psp to its rolebinding. 
This new rolebinding may not be needed if the service account is already using a higher privialged rolebinding, such as `cluster-admin`. 

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: miniovelero
  namespace: velero
  labels:
    component: minio

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: velero-privileged
  namespace: velero
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: wcp-privileged-psp
subjects:
- namespace: velero
  kind: ServiceAccount
  name: miniovelero
```

### Step 3.  Modify the container(s) specific parameters by adding the following relevent details

```yaml
      hostNetwork: true  #IMPORTANT
      serviceAccount: miniovelero #Reference service account above
      serviceAccountName: miniovelero #Reference service account above
      nodeSelector: 
        node-role.kubernetes.io/master: ""
      tolerations:
      - key: CriticalAddonsOnly
        operator: Exists
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
        operator: Exists
```
