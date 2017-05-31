#!/bin/bash

if [ -z $1 ];
then
   echo 'Input named volume'
   exit 0
fi

docker volume ls -q | grep -x $1
if [ $? -ne 0 ];
then
   echo -e "\033[00;31m ERROR! Volume $1 not found \033[0m"
   echo "List of docker volumes: "
   docker volume ls -q | grep $1i
   exot 0
fi

# exit 0

VOLUME_NAME=$1
CURRENT_DATETIME=$(date '+%Y-%m-%d_%H-%M-%S')
EXPORT_DIR="${VOLUME_NAME}-${CURRENT_DATETIME}"
mkdir ${EXPORT_DIR}

docker run --rm -it -v $(readlink -f ${EXPORT_DIR}):/tmp/export/data \
    -v ${VOLUME_NAME}:/tmp/export/volume ubuntu \
    /bin/bash -c "cd /tmp/export/volume \
        && tar -czvf /tmp/export/data/data.tar.gz . "


