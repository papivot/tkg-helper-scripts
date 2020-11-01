export tkgrimage="ob-16924026-photon-3-k8s-v1.18.5---vmware.1-tkg.1.c40d30d"
wget --no-parent -r -nH --cut-dirs=2 --reject="index.html*" https://wp-content.vmware.com/v2/latest/${tkgrimage}/
cd ${tkgrimage}
# sed -i Capacty:16 -> Capacity:32
#sha1sum photon-ova.ovf  and move copy the value to manifest 
govc library.import -n ${tkgrimage} -m=true Local photon-ova.ovf
