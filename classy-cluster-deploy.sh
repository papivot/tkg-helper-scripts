#!/bin/bash

#tanzu init
#tanzu plugin sync
#tanzu plugin list
tanzu login --endpoint https://192.168.12.50 --name supervisor0
#tanzu plugin list

tanzu namespaces get
tanzu kubernetes-release get
wget https://raw.githubusercontent.com/papivot/tkg-helper-scripts/main/tkgs-cluster-class-noaz.yaml
tanzu cluster create -f tkgs-cluster-class-noaz.yaml
tanzu cluster kubeconfig  get workload-vsphere-tkg1 -n demo1

kubectl config use-context tanzu-cli-workload-vsphere-tkg1@workload-vsphere-tkg1
kubectl apply -f https://raw.githubusercontent.com/papivot/tkg-helper-scripts/main/modify-psp-guestcluster.yaml

kubectl create ns tanzu-package-repo-global
tanzu package repository add tanzu-standard --url projects.registry.vmware.com/tkg/packages/standard/repo:v1.6.0 -n tanzu-package-repo-global
tanzu package available list -n tanzu-package-repo-global
tanzu package repository get tanzu-standard -n tanzu-package-repo-global
# tanzu package available list cert-manager.tanzu.vmware.com -n tanzu-package-repo-global
# tanzu package available list contour.tanzu.vmware.com -n tanzu-package-repo-global
tanzu package install cert-manager -p cert-manager.tanzu.vmware.com -v 1.7.2+vmware.1-tkg.1 -n tanzu-package-repo-global
#kubectl get pods -A
wget https://raw.githubusercontent.com/papivot/tanzu-packages-for-tkgs/master/Contour/contour-data-values.yaml
tanzu package install contour -p contour.tanzu.vmware.com -v 1.20.2+vmware.1-tkg.1 -n tanzu-package-repo-global --values-file contour-data-values.yaml
# tanzu package installed list -n tanzu-package-repo-global