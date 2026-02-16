# Computing metrics with event-level experiment data

In this Lab, we'll walk through an end-to-end workflow for computing a series of metrics with data collected by both Optimizely and a third party during an Optimizely Full Stack experiment.

## Running this notebook

This lab runs using [Docker](https://www.docker.com/), which provides all necessary dependencies (Python, Java, Spark, Jupyter). The lab includes a `Dockerfile` that builds a custom image from the official `python:3.11-slim` base image, installing all dependencies via standard package managers (apt and pip).

### Prerequisites

- [Docker](https://www.docker.com/) must be installed on your system

### Running the notebook with `run.sh`

You can use the `run.sh` script to run this notebook with a single command:

```sh
bash bin/run.sh
```

This script will:
1. Build a custom Docker image from the local Dockerfile
2. Install lab-specific Python dependencies
3. Launch Jupyter Lab

That's it, you're done!

### Running the notebook directly with Docker

Alternatively, you can execute `run-docker.sh` directly:

```sh
bash bin/run-docker.sh
```

**Note:** Docker makes it easy to get started with PySpark, but it may require [additional configuration](https://docs.docker.com/config/containers/resource_constraints/) to handle large workloads.

## Specifying a custom data directory

The notebook in this lab will load Enriched Event data from `example_data/` in the lab directory.  If you wish to load data from another directory, you can use the `OPTIMIZELY_DATA_DIR` environment variable.  For example:

```sh
export OPTIMIZELY_DATA_DIR=~/optimizely_data
```

Once `OPTIMIZELY_DATA_DIR` has been set, launch Jupyter Lab using one of the approaches described above.  The Lab notebook should load data from your custom directory.