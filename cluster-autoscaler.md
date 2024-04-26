
Create a file called `cluster-autoscaler.yaml`

```yaml
# arguments:
#   ignoreDaemonsetsUtilization: true
#   maxNodeProvisionTime: 15m
#   maxNodesTotal: 0
#   metricsPort: 8085
#   scaleDownDelayAfterAdd: 10m
#   scaleDownDelayAfterDelete: 10s
#   scaleDownDelayAfterFailure: 3m
#   scaleDownUnneededTime: 10m
clusterConfig:
  clusterName: "workload-vsphere-tkg5"
  clusterNamespace: "demo1"
# paused: false
```

```bash
tanzu package repository add tanzu-standard --url projects.registry.vmware.com/tkg/packages/standard/repo:v2024.4.12 --namespace tkg-system
tanzu package available list cluster-autoscaler.tanzu.vmware.com -n tkg-system
tanzu package available get cluster-autoscaler.tanzu.vmware.com/1.27.2+vmware.1-tkg.3 -n tkg-system --default-values-file-output cluster-autoscaler.yaml
tanzu package install cluster-autoscaler --package cluster-autoscaler.tanzu.vmware.com --namespace tkg-system --version 1.27.2+vmware.1-tkg.3 --values-file cluster-autoscaler.yaml
```

