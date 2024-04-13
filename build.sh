#!/bin/bash

PG_REPACK=(
    "12,1.4.5"
    "13,1.4.6"
    "14,1.4.7"
    "15,1.4.8"
    "16,1.5.0"
)

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
    echo "** Trapped CTRL-C"
    exit 1
}

#docker login -u XXXXX -p YYYYY

for DATA in ${PG_REPACK[@]}; do
    PG_VER=$(echo "${DATA}" | awk -F',' '{print $1}')
    PGREPACK_VER=$(echo "${DATA}" | awk -F',' '{print $2}')
    echo "Docker build image 'pg-repack:${PGREPACK_VER}', postgres v${PG_VER}..."
    docker build -t cherts/pg-repack:${PGREPACK_VER} --no-cache --progress=plain -f ${PG_VER}/Dockerfile ${PG_VER}
    if [ $? -eq 0 ]; then
        echo "Docker push image 'pg-repack:${PGREPACK_VER}'..."
        docker push cherts/pg-repack:${PGREPACK_VER}
    else
        echo "ERROR: Failed build image 'pg-repack:${PGREPACK_VER}', postgres v${PG_VER}"
        exit 1
    fi
done