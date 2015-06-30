#!/usr/bin/env bash

NAME="rpm-builder-waf"
TAG="${NAME}:${BUILD_NUMBER:-1}"
CONTAINER_NAME="${NAME}-build-${BUILD_NUMBER:-1}"

docker build -t $TAG . && \
docker run \
    --name=$NAME \
    -e "RPM_OUTPUT_DIR=/rpms" \
    -v "$(pwd):/rpms" \
    $TAG && \
docker rm $NAME
