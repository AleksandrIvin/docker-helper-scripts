# docker-helper-scripts

## docker-helper-pgdump


```docker-helper-pgdump docker_network container_host db_user db_password db_name pg_version options```

- docker network
- container host
- db_user
- db_password
- db_name
- pg_version
- options

```docker-helper-pgdump apps_default apps_db user1 simplepass testdb 9.4 -C```


## docker-helper-pgrestore

```docker-helper-pgrestore docker_network container_host db_user db_password db_name pg_version backup-db.gz```

- docker network
- container host
- db_user
- db_password
- db_name
- pg_version
- pg_dump_file

```docker-helper-pgrestore apps_default apps_db db_user db_password db_name 9.4 pa1-2017-02-28_10-21-05.gz```
