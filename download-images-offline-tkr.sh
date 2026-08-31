#!/bin/bash

if ! command -v jq >/dev/null 2>&1 ; then
  echo "JQ not installed. Exiting...."
  exit 1
fi
if ! command -v wget >/dev/null 2>&1 ; then
  echo "wget not installed. Exiting...."
  exit 1
fi

echo
echo "The VMware subscribed content library has the following Tanzu Kubernetes Release images ... "
echo
curl -s https://wp-content.vmware.com/v2/latest/items.json |jq -r '[.items[] | {name: .name, created: .created}] | sort_by(.created) | .[].name'
echo
read -p "Enter the name of the TanzuKubernetesRelease OVA that you want to download and zip for offline upload: " tkgrimage
echo
echo "Downloading all files for the TKG image: ${tkgrimage} ..."
echo
wget -q --show-progress --no-parent -r -nH --cut-dirs=2 --reject="index.html*" https://wp-content.vmware.com/v2/latest/${tkgrimage}/
echo "Compressing downloaded files..."
tar -cvzf ${tkgrimage}.tar.gz ${tkgrimage}
echo
echo "Cleaning up..."
[ -d "${tkgrimage}" ] && rm -rf ${tkgrimage}
echo "Copy the file ${tkgrimage}.tar.gz to the offline jumpbox that has access to the cluster."
echo "Install and configure govc on the offline jumpbox."
echo "Use the following command on that jumpbox to import the image to the vCenter Content Library called "Local"..."
echo
echo "     tar -xzvf ${tkgrimage}.tar.gz"
echo "     cd ${tkgrimage}"
echo "     govc library.import -n ${tkgrimage} -m=true Local photon-ova.ovf"
echo "     or"
echo "     govc library.import -n ${tkgrimage} -m=true Local ubuntu-ova.ovf"