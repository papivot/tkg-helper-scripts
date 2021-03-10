kubectl get secrets -n vmware-system-registry-xxxxxxxx harbor-xxxxxxxx-controller-registry -o json|jq -r '.data.harborAdminPassword'|base64 -d|base64 -d;echo
