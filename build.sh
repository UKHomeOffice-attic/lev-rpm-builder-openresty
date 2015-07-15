#!/usr/bin/env bash

set -e

NAME="rpm-builder-waf"
TAG="${NAME}:${BUILD_NUMBER:-1}"
CONTAINER_NAME="${NAME}-build-${BUILD_NUMBER:-1}"

BUILD_HOME=$( cd "$( dirname  "${BASH_SOURCE[0]}" )" && pwd )
TEMP_EXTENSION=tmp-$CONTAINER_NAME-$(date +"%s")
SHARED_TEMP_HOST=${SHARED_JENKINS_PATH_HOST:-$BUILD_HOME}/$TEMP_EXTENSION
SHARED_TEMP_CONTAINER=${SHARED_JENKINS_PATH_CONTAINER:-$BUILD_HOME}/$TEMP_EXTENSION

mkdir -p "${SHARED_TEMP_CONTAINER}"

if [ ${SUDO:-1} -eq "1" ]; then
    set +e
    sudo docker rm $CONTAINER_NAME
    set -e
    sudo docker build -t $TAG . && \
    sudo docker run \
        --name=$CONTAINER_NAME \
        -e "RPM_OUTPUT_DIR=/rpms" \
        -v "$SHARED_TEMP_HOST:/rpms" \
        $TAG && \
    sudo docker rm $CONTAINER_NAME
else
    set +e
    docker rm $CONTAINER_NAME
    set -e
    docker build -t $TAG . && \
    docker run \
        --name=$CONTAINER_NAME \
        -e "RPM_OUTPUT_DIR=/rpms" \
        -v "$SHARED_TEMP_HOST:/rpms" \
        $TAG && \
    docker rm $CONTAINER_NAME
fi

cp $SHARED_TEMP_HOST/* $BUILD_HOME
rm -rf $SHARED_TEMP_HOST
