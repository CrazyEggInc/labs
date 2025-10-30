# Use official Python image
FROM python:3.11-slim

# Install Java (required for PySpark)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-21-jre-headless \
    wget \
    curl \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-arm64

# Install PySpark and Jupyter via pip
RUN pip install --no-cache-dir \
    pyspark==3.5.0 \
    jupyterlab==4.0.9 \
    notebook \
    ipykernel \
    ipywidgets

# Create a non-root user
RUN useradd -m -s /bin/bash jovyan
USER jovyan
WORKDIR /home/jovyan

# Expose Jupyter port
EXPOSE 8888

# Default command
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
