# pg_repack docker image (using alpine linux)

[![Docker pulls)](https://img.shields.io/docker/pulls/cherts/pg-repack.svg)](https://hub.docker.com/r/cherts/pg-repack)
![LICENSE](https://img.shields.io/github/license/cherts/pg_repack_docker)

Docker image with 'pg_repack' (PostgreSQL extension) installed, can  be used 'client-side' to run/invoke pg_repack functionality for a PostgreSQL database with the extension installed.

Reference: https://github.com/reorg/pg_repack

## Versions

This images follows the pg_repack releases + compatibility with PostgreSQL.

| image | postgres | pg_repack |
|-------|----------|-----------|
| cherts/pg-repack:1.5.1 | 17       | 1.5.1     |
| cherts/pg-repack:1.5.0 | 16       | 1.5.0     |
| cherts/pg-repack:1.4.8 | 15       | 1.4.8     |
| cherts/pg-repack:1.4.7 | 14       | 1.4.7     |
| cherts/pg-repack:1.4.6 | 13       | 1.4.6     |
| cherts/pg-repack:1.4.5 | 12       | 1.4.5     |

## Dockerhub

https://hub.docker.com/r/cherts/pg-repack/


### Build image

```
git clone https://github.com/CHERTS/pg_repack_docker.git
cd pg_repack_docker
./build.sh
```
    
### Run pg_repack

This image contains the pg_repack utility to run with the official images [postgres docker image](https://hub.docker.com/_/postgres/)
    
This image may be required to run pg_repack on your computer if your postgres is running in cloud or in a container (kubernetes) that already has the pg_repack extension.

```
# use pg_repack v1.5.0
docker run -it --rm --name pg_repack cherts/pg-repack:1.5.0 --version
docker run -it --rm --name pg_repack cherts/pg-repack:1.5.0 -h X.X.X.X -U postgres --dbname=dbname --table=table1 --only-indexes --no-superuser-check --dry-run
```

### Additional utilities in this image

This image contains the ability to run additional utilities that come with postgres - psql, pgbench, pg_dump, pg_dumpall, pg_basebackup, pg_restore, pg_verifybackup and pg_controldata

For example, we can run pgbench in our cloud database like this:
```
# use postgres v16
# run init
docker run -it --rm --name pg_repack cherts/pg-repack:1.5.0 pgbench -h X.X.X.X -p 5432 -U postgres test -i -s 10
# run test
docker run -it --rm --name pg_repack cherts/pg-repack:1.5.0 pgbench -h X.X.X.X -p 5432 -U postgres test -T 60 -j 4 -P 2
# run drop test data
docker run -it --rm --name pg_repack cherts/pg-repack:1.5.0 pgbench -h X.X.X.X -p 5432 -U postgres test -i -I d
```
