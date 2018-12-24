#!/bin/bash

NETWORK=$1
CONTAINER_NAME=$2
DB_USER=$3
DB_PASSWORD=$4
DB_NAME=$5
PG_VERSION=$6
PG_DUMP_FILE=$7
PG_DUMP_DIR=$(readlink -e ${PG_DUMP_FILE})

echo $PG_DUMP_DIR
#exit 0

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

DB_PATH=$(readlink -f $(dirname ${PG_DUMP_FILE}))
DB_BASENAME=$(basename ${PG_DUMP_FILE})
#docker volume ls -q | grep -x $1
#if [ $? -ne 0 ];
#then
#   echo -e "\033[00;31m ERROR! Volume $1 not found \033[0m"
#   echo "List of docker volumes: "
#   docker volume ls -q | grep $1i
#   exit 1
#fi

# exit 0

echo "export PGPASSWORD=${DB_PASSWORD} && cd /tmp/export/data \
        && gzip -c dump.gz | psql -h dbhost -U ${DB_USER} ${DB_NAME}"
echo `pwd`

docker run --rm -it -v $DB_PATH:/tmp/export/data \
    -e POSTGRES_PASSWORD=${DB_PASSWORD} \
    --link ${CONTAINER_NAME}:dbhost \
    --network ${NETWORK} \
    postgres:${PG_VERSION} \
    /bin/bash -c "export PGPASSWORD=${DB_PASSWORD} && cd /tmp/export/data \
        && gunzip -c ${DB_BASENAME} | psql -h dbhost -U ${DB_USER} ${DB_NAME}"

