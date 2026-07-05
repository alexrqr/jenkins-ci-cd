# Use the Jenkins base image
FROM jenkins/jenkins:lts

# Switch to the root user
USER root

# Install required packages and Docker
RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
        wget && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Maven
ARG MAVEN_VERSION=3.9.8
RUN wget --no-verbose https://downloads.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -P /tmp/ && \
    tar xzf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt/ && \
    ln -s /opt/apache-maven-$MAVEN_VERSION /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/local/bin && \
    rm /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz

# Set up environment variables for Maven
ENV MAVEN_HOME=/opt/maven

# Add Jenkins user to Docker group
RUN usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins
