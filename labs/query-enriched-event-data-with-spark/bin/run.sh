#!/bin/bash

# run.sh
#
# A handy script for running the Lab notebook locally using Docker
# This script requires Docker to be installed

set -e

SCRIPT_DIR=$(dirname "$0")

echo "==================================================================================="
echo "This lab runs using Docker."
echo "Please ensure Docker is installed on your system."
echo ""
echo "Docker provides all necessary dependencies (Python, Spark, Jupyter)."
echo ""
if [[ -z "${OPTIMIZELY_DATA_DIR:-}" ]]; then
    echo "Note: If you'd like to run this notebook using data stored in a different"
    echo "      directory, set the OPTIMIZELY_DATA_DIR environment variable first."
    echo "      For example: export OPTIMIZELY_DATA_DIR=~/optimizely_data"
    echo ""
fi
echo "Starting Docker container..."
echo "==================================================================================="

# Call the Docker run script
bash "$SCRIPT_DIR/run-docker.sh"