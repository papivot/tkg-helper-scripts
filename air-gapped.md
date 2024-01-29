# vCenter Configuration

1. Use the `download-images-offline-tkr.sh` script to relocate images to the airgapped vCenter. 


# Supervisor Configuration

1. Create a public repository within the internal registry. Upload the necessary images/manifests that need to be executed on the Supervisor, such as Supervisor Services. 

2. Download the cert of the Registry

```
sudo wget -O ~/Downloads/ca.crt https://$REGISTRY/api/v2.0/systeminfo/getcert --no-check-certificate
# Above example is for Harbor
```

3. Modify the Configmap *image-fetcher-ca-bundle* and update the CM with the Registry certificate.

```
k edit cm -n kube-system image-fetcher-ca-bundle
```

4. Modify the secret of the kapp controller `kapp-controller-config`. Get the current secret, base64 decode, append the Registry certificate. Base64 encode and update the new secret. 

```
k edit secret -n vmware-system-appplatform-operator-system kapp-controller-config
```

# Workload Cluster Configuration