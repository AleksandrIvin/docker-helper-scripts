#!/bin/bash

NETWORK=$1
CONTAINER_NAME=$2
DB_USER=$3
DB_PASSWORD=$4
DB_NAME=$5
PG_VERSION=$6
PG_DUMP_OPTIONS=$7

if [ -z $NETWORK ];
then
   echo 'EMPTY NETWORK'
   exit 1
fi

if [ -z $CONTAINER_NAME ];
then
   echo 'EMPTY CONTAINER_NAME'
   exit 1
fi

if [ -z $DB_PASSWORD ];
then
   echo 'EMPTY DB_USER'
   exit 1
fi

if [ -z $DB_NAME ];
then
   echo 'EMPTY DB_NAME'
   exit 1
fi

#docker volume ls -q | grep -x $1
#if [ $? -ne 0 ];
#then
#   echo -e "\033[00;31m ERROR! Volume $1 not found \033[0m"
#   echo "List of docker volumes: "
#   docker volume ls -q | grep $1i
#   exit 1
#fi

# exit 0

CURRENT_DATETIME=$(date '+%Y-%m-%d_%H-%M-%S')
#EXPORT_DIR="${CONTAINER_NAME}-${CURRENT_DATETIME}"
#mkdir ${EXPORT_DIR}

docker run --rm -it -v `pwd`:/tmp/export/data \
    -e POSTGRES_PASSWORD=${DB_PASSWORD} \
    --link ${CONTAINER_NAME}:dbhost \
    --network ${NETWORK} \
    postgres:${PG_VERSION} \
    /bin/bash -c "export PGPASSWORD=${DB_PASSWORD} && cd /tmp/export/data \
        && pg_dump -h dbhost -U ${DB_USER} ${DB_NAME} ${PG_DUMP_OPTIONS} | gzip -c > ${CONTAINER_NAME}-${DB_NAME}-${CURRENT_DATETIME}.gz \
        && chmod 0766 ${CONTAINER_NAME}-${DB_NAME}-${CURRENT_DATETIME}.gz"

printf "${NETWORK}\n${CONTAINER_NAME}\n${CONTAINER_NAME}-${DB_NAME}-${CURRENT_DATETIME}.gz\n" >> ${CONTAINER_NAME}.txt

