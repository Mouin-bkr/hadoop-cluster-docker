# Start from a stable Ubuntu base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies: Java, SSH, and networking tools
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    ssh \
    wget \
    net-tools && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME and HADOOP_HOME environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Download and extract Hadoop 3.4.1
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz -O /tmp/hadoop.tar.gz && \
    tar -xzvf /tmp/hadoop.tar.gz -C /usr/local/ && \
    mv /usr/local/hadoop-3.4.1 /usr/local/hadoop && \
    rm /tmp/hadoop.tar.gz

# Copy your proven configuration files into the image
COPY core-site.xml $HADOOP_CONF_DIR/
COPY hdfs-site.xml $HADOOP_CONF_DIR/
COPY mapred-site.xml $HADOOP_CONF_DIR/
COPY yarn-site.xml $HADOOP_CONF_DIR/
COPY hadoop-env.sh $HADOOP_CONF_DIR/

# Set up passwordless SSH for Hadoop daemons
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# Expose Hadoop service ports
# NameNode UI
EXPOSE 9870
# ResourceManager UI
EXPOSE 8088
# DataNode Ports
EXPOSE 9864
# NodeManager Port
EXPOSE 8042

# Create a startup script
COPY <<'EOF' /usr/local/bin/start-hadoop.sh
#!/bin/bash
# Format NameNode on first run
if [ ! -d "/usr/local/hadoop/data/nameNode" ]; then
  echo "Formatting NameNode..."
  hdfs namenode -format
fi

# Start SSH service
service ssh start

# Start Hadoop services
start-dfs.sh
start-yarn.sh

# Keep the container running
tail -f /dev/null
EOF

# Make the startup script executable
RUN chmod +x /usr/local/bin/start-hadoop.sh

# Define the default command to run when the container starts
CMD ["start-hadoop.sh"]
