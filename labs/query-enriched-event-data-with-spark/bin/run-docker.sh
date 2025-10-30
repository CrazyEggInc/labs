#!/bin/bash

# run-docker.sh
#
# A handy script for running the lab notebook locally in a docker container
# Uses a custom Docker image built from python:3.11-slim

set -e

# Use the script path to build an absolute path for the Lab's base directory
SCRIPT_DIR=$(dirname "$0")
. "$SCRIPT_DIR/base.sh"

# Build the Docker image from local Dockerfile
IMAGE_NAME="optimizely-pyspark-lab"
echo "Building Docker image..."
docker build -t "$IMAGE_NAME" "$LAB_BASE_DIR"

# The Lab directory should be mounted in ~/lab in the container
CONTAINER_HOME=/home/jovyan
CONTAINER_LAB_BASE_DIR="$CONTAINER_HOME/lab"

# Build the startup command to install dependencies and launch Jupyter
STARTUP_CMD="pip install -r $CONTAINER_LAB_BASE_DIR/requirements.txt && \
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password='' --notebook-dir=$CONTAINER_LAB_BASE_DIR"

# Detect if running in interactive terminal
DOCKER_FLAGS=""
if [ -t 0 ]; then
    DOCKER_FLAGS="-it"
fi

# If OPTIMIZELY_DATA_DIR is defined, mount the specified data directory in
# the container and set the container OPTIMIZELY_DATA_DIR envar accordingly
echo "Starting docker container"
if [[ -n "${OPTIMIZELY_DATA_DIR:-}" ]]; then
    CONTAINER_DATA_DIR="$CONTAINER_HOME/optimizely_data"
    echo "OPTIMIZELY_DATA_DIR envar set.  Mapping to $CONTAINER_DATA_DIR"

    docker run $DOCKER_FLAGS --rm \
        -p 8888:8888 \
        -v "$LAB_BASE_DIR:$CONTAINER_LAB_BASE_DIR" \
        -v "$OPTIMIZELY_DATA_DIR:$CONTAINER_DATA_DIR" \
        -e "OPTIMIZELY_DATA_DIR=$CONTAINER_DATA_DIR" \
        "$IMAGE_NAME" \
        bash -c "$STARTUP_CMD"
else
    docker run $DOCKER_FLAGS --rm \
        -p 8888:8888 \
        -v "$LAB_BASE_DIR:$CONTAINER_LAB_BASE_DIR" \
        "$IMAGE_NAME" \
        bash -c "$STARTUP_CMD"
fi
