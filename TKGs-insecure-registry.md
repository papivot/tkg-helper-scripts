# Configuring and using insecure registries on TKGs clusters
### Not for production use
---

Note: This is intended for one-time use. As cluster nodes may scale out or scale in, we would have to perform these steps on the new nodes manually.

Log in to each of the nodes (workers and control plane nodes) and perform the following steps - 

1. Make a backup of the config.toml file 
```
cd /etc/containerd
sudo cp -p config.toml config.toml_backup
```

2. Edit the `config.toml` file and add the following entries -
 ```
 sudo vi config.toml
 ```
 
 Lines to append at the appropriate `[plugins.cri.registry]` section
 
```
      [plugins.cri.registry.configs]
        [plugins.cri.registry.configs."my.insecure.registry"]
          [plugins.cri.registry.configs."my.insecure.registry".tls]
            insecure_skip_verify = true
```
where `my.insecure.registry` is the name of the registry that needs to be configured to skip SSL validation

The final file should like something like this - 
```
...
    [plugins.cri.registry]
      [plugins.cri.registry.mirrors]
        [plugins.cri.registry.mirrors."docker.io"]
          endpoint = ["https://registry-1.docker.io"]
      [plugins.cri.registry.configs]
        [plugins.cri.registry.configs."192.168.10.167"]
          [plugins.cri.registry.configs."192.168.10.167".tls]
            insecure_skip_verify = true
...
```

3. Restart the containerd daemon.
```
sudo systemctl restart containerd
```

4. Validate the daemon restarted successfully 
```
sudo systemctl status containerd
```
