#!/bin/bash

NETWORK=$1
CONTAINER_NAME=$2
DB_USER=$3
DB_PASSWORD=$4
DB_NAME=$5
PG_VERSION=$6
PG_DUMP_FILE=$7
PG_RESTORE_JOBS=$8
PG_DUMP_DIR=$(readlink -e ${PG_DUMP_FILE})

echo $PG_DUMP_DIR

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

if [ -z $PG_RESTORE_JOBS ];
then
   PG_RESTORE_JOBS=1
fi

DB_PATH=$(readlink -f $(dirname ${PG_DUMP_FILE}))
DB_BASENAME=$(basename ${PG_DUMP_FILE})
TMP_DUMP_DIR=tmp_dump_dir

echo `pwd`

docker run --rm -it -v $DB_PATH:/tmp/export/data \
    -e POSTGRES_PASSWORD=${DB_PASSWORD} \
    --link ${CONTAINER_NAME}:dbhost \
    --network ${NETWORK} \
    postgres:${PG_VERSION} \
    /bin/bash -c "export PGPASSWORD=${DB_PASSWORD} && cd /tmp/export/data \
        && mkdir -p ${TMP_DUMP_DIR} && tar -C ${TMP_DUMP_DIR}  --strip-components=1 -xvf ${DB_BASENAME} \
        && pg_restore --version && sleep 2 \
        && pg_restore -v -h dbhost -U ${DB_USER} -d ${DB_NAME} -j ${PG_RESTORE_JOBS} -F d ${TMP_DUMP_DIR} || true \
        && rm -r ${TMP_DUMP_DIR}"

