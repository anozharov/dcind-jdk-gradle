# Inspired by https://github.com/mumoshu/dcind
FROM alpine:3.11
LABEL maintainer="Sebastijan Grabar <sebastijan.grabar@comsysto.com>"

ENV DOCKER_VERSION=19.03.8 \
    DOCKER_COMPOSE_VERSION=1.25.4

# Install Docker and Docker Compose
RUN apk --no-cache add bash curl util-linux device-mapper libffi-dev openssl-dev gcc libc-dev make iptables openjdk11 docker-compose && \
    curl https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar zx && \
    mv /docker/* /bin/ && \
    chmod +x /bin/docker* && \
    rm -rf /root/.cache

# Gradle

ARG GRADLE_VERSION=7.4.2

RUN mkdir -p /opt/gradle && \
  mkdir /tmp/gradle_download_folder && \
  cd /tmp/gradle_download_folder && \
  wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
  unzip -d /opt/gradle gradle-$GRADLE_VERSION-bin.zip && \
  rm gradle-$GRADLE_VERSION-bin.zip

ENV PATH=$PATH:/opt/gradle/gradle-$GRADLE_VERSION/bin
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

# Include functions to start/stop docker daemon
COPY docker-lib.sh /docker-lib.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
