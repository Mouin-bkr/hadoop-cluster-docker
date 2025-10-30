Standalone Hadoop 3.4.1 Cluster on Docker

This repository contains a Docker image for a fully configured, single-node Hadoop 3.4.1 cluster running on Ubuntu 22.04.

This image is pre-configured with all necessary environment variables and Java compatibility fixes to provide a stable, out-of-the-box Hadoop environment for development and testing.
Features

    Hadoop Version: 3.4.1

    Java Version: OpenJDK 11

    Operating System: Ubuntu 22.04

    Services: NameNode, DataNode, SecondaryNameNode, ResourceManager, NodeManager.

    Pre-configured: Includes all necessary XML configurations and hadoop-env.sh modifications for compatibility with modern Java versions.

Usage

To run a container from this image, execute the following command. This will start the container in detached mode, name it hadoop-cluster, and map the necessary web UI ports to your local machine.

bash
docker run -d --name hadoop-cluster -p 9870:9870 -p 8088:8088 razer99/hadoop-cluster-mouin-boubakri

Accessing Web UIs

Once the container is running, you can access the Hadoop services from your web browser:

    HDFS NameNode UI: http://localhost:9870

    YARN ResourceManager UI: http://localhost:8088

Interacting with the Container

To get a shell inside the running container for debugging or running Hadoop commands:

bash
    
    docker exec -it hadoop-cluster /bin/bash

![Hadoop Logo](https://raw.githubusercontent.com/razer99/hadoop-cluster-mouin-boubakri/main/hadoop_logo.png)

