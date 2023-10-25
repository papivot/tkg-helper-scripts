#!/bin/bash

#Modify these two values as needed
INPUTFILE=contour.yaml
NEWREPO=harbor-repo.vmware.com/navneetv/library

declare -a images_to_export=()
NEW_REGISTRY=`echo $NEWREPO|cut -d / -f 1`
for image in `grep image: ${INPUTFILE}|sort|uniq|awk '{print $2}'`
do
	image_name=`echo ${image}|rev|cut -d / -f 1|rev`
	new_image_name=${NEWREPO}/${image_name}
	images_to_export=(${images_to_export[@]} ${new_image_name})

	docker pull ${image}
        docker tag  ${image} ${new_image_name}
done
echo
echo Docker images to export - ${images_to_export[@]}
rm -f $INPUTFILE.tar
rm -f $INPUTFILE.tar.gz
docker save ${images_to_export[@]} -o $INPUTFILE.tar
gzip $INPUTFILE.tar
echo
echo "The docker images have been exported to - $INPUTFILE.tar.gz. Please copy this file a system in the airgapped environment running docker."
echo "Run the following commands on the environment to load to the images locally - "
echo "$ gzip -d $INPUTFILE.tar.gz"
echo "$ docker load -i $INPUTFILE.tar"
echo
echo "To upload the images to the private registry - $NEWREPO - run the following commands for each of the images uploaded in the previous step. "
echo "$ docker images"
echo "$ docker login -u username $NEW_REGISTRY"
echo "$ docker push image(s)_name"
