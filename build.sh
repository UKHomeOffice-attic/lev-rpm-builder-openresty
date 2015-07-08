#!/usr/bin/env bash

NAME="rpm-builder-waf"
TAG="${NAME}:${BUILD_NUMBER:-1}"
CONTAINER_NAME="${NAME}-build-${BUILD_NUMBER:-1}"

TEMP_EXTENSION=tmp-$CONTAINER_NAME-$(date +"%s")
SHARED_TEMP_HOST=${SHARED_JENKINS_PATH_HOST:-$(pwd)}/$TEMP_EXTENSION
SHARED_TEMP_CONTAINER=${SHARED_JENKINS_PATH_CONTAINER:-$(pwd)}/$TEMP_EXTENSION

mkdir -p "${SHARED_TEMP_CONTAINER}"


if [ ${SUDO:-1} -eq "1" ]; then
    sudo docker rm $CONTAINER_NAME ;
    sudo docker build -t $TAG . && \
    sudo docker run \
        --name=$CONTAINER_NAME \
        -e "RPM_OUTPUT_DIR=/rpms" \
        -v "$SHARED_TEMP_HOST:/rpms" \
        $TAG && \
    sudo docker rm $CONTAINER_NAME
else
    docker rm $CONTAINER_NAME ;
    docker build -t $TAG . && \
    docker run \
        --name=$CONTAINER_NAME \
        -e "RPM_OUTPUT_DIR=/rpms" \
        -v "$SHARED_TEMP_HOST:/rpms" \
        $TAG && \
    docker rm $CONTAINER_NAME
fi

cp $SHARED_TEMP_CONTAINER/* $(pwd)
rm -rf $SHARED_TEMP_CONTAINER
