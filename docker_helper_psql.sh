#!/bin/bash

NETWORK=$1
CONTAINER_NAME=$2
DB_USER=$3
DB_PASSWORD=$4
DB_NAME=$5
PG_VERSION=$6
PG_SQL_FILE=$7
PG_SQL_DIR=$(dirname $(readlink -e ${PG_SQL_FILE}))

STARTED_DATE=$(date)
# echo ${PG_SQL_DIR}
# exit 0

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

# echo "export PGPASSWORD=${DB_PASSWORD} && cd /tmp/export/data \
#        && cat ${PG_SQL_FILE} | psql -h dbhost -U ${DB_USER} ${DB_NAME}"
echo ${PG_SQL_FILE}

echo "Started:"
echo ${STARTED_DATE}
docker run --rm -v ${PG_SQL_DIR}:/tmp/psql \
    -e POSTGRES_PASSWORD=${DB_PASSWORD} \
    --link ${CONTAINER_NAME}:dbhost \
    --network ${NETWORK} \
    postgres:${PG_VERSION} \
    /bin/bash -c "export PGPASSWORD=${DB_PASSWORD} && cd /tmp/psql \
        && cat ${PG_SQL_FILE} | psql -h dbhost -U ${DB_USER} ${DB_NAME}"

echo ${PG_SQL_FILE}
echo "Started:"
echo ${STARTED_DATE}
echo "Finished:"
echo $(date)
echo "--------"
