#!/bin/sh
echo
echo "The VMware subscribed content library has the following images: "
echo
curl -s https://wp-content.vmware.com/v2/latest/items.json |jq -r '.items[].name'
echo
read -p "Enter the name of the content library that you want to download and zip for offline upload: " tkgrimage
echo
echo Downloading all files for the TKG image: ${tkgrimage}
echo
wget -q --show-progress --no-parent -r -nH --cut-dirs=2 --reject="index.html*" https://wp-content.vmware.com/v2/latest/${tkgrimage}/
echo "Compressing downloaded files"
tar -cvzf ${tkgrimage}.tar.gz ${tkgrimage} --totals
echo
echo "Cleaning up..."
[ -d "${tkgrimage}" ] && rm -rf ${tkgrimage}
