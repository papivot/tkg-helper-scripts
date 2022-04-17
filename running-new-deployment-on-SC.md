# Modify the deployment/DS to add the follwowing - 

## Create new service account and add allow wcp-privilaged-psp to the rolebinding

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

## Modify the container parameters by adding the following relevent details

```yaml
      hostNetwork: true
      serviceAccount: miniovelero
      serviceAccountName: miniovelero
      nodeSelector:
        node-role.kubernetes.io/master: ""
      tolerations:
      - key: CriticalAddonsOnly
        operator: Exists
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
        operator: Exists
```
