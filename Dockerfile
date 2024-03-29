ARG DEBIAN_FRONTEND=noninteractive
ARG ARTEMIS_GIT_REPOSITORY=https://github.com/ls1intum/Artemis
ARG ARTEMIS_VERSION=develop

####################
# Build stage      #
####################
FROM openjdk:17-jdk-buster AS build

ENV LC_ALL C

RUN echo "Installing prerequisites" \
  && apt-get update && apt-get install -y --no-install-recommends curl \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get update && apt-get install -y --no-install-recommends \
  git \
  nodejs \
  && npm install --global yarn

ARG ARTEMIS_VERSION
ARG ARTEMIS_GIT_REPOSITORY

# Builds the server without client
# Use ./gradlew -Pprod -Pwar clean bootWar and change .jar to .war 
# to run the server with client included.
RUN echo "Building from $ARTEMIS_GIT_REPOSITORY" \
  && mkdir /build && cd /build \
  && git clone --depth 1 --branch $ARTEMIS_VERSION $ARTEMIS_GIT_REPOSITORY \
  && cd Artemis \
  && ./gradlew build -x webapp -x test -x jacocoTestCoverageVerification

RUN cd /build/Artemis \
  && mv /build/Artemis/build/libs/Artemis-$(./gradlew properties -q | grep "^version:" | awk '{print $2}').jar \
  /build/Artemis/build/libs/Artemis.jar

####################
# Execution stage  #
####################
FROM openjdk:17-jdk-buster

ARG ARTEMIS_VERSION
ARG GOSU_VERSION=1.12
ENV PROFILES=prod,jenkins,gitlab,artemis,scheduling
ENV LC_ALL C

LABEL maintainer "Lucas Alber <lucasd.alber@gmail.com>"

RUN echo "Installing prerequisites" \
  && apt-get update && apt-get install -y --no-install-recommends \
  supervisor \
  netcat \
  graphviz \
  && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

COPY bootstrap.sh /bootstrap.sh
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY stop-supervisor.sh /usr/local/sbin/stop-supervisor.sh

RUN mkdir -p /opt/Artemis/config /opt/Artemis/data /defaults/Artemis

COPY --from=build /build/Artemis/build/libs /opt/Artemis
COPY --from=build /build/Artemis/build/resources/main/config /defaults/Artemis

RUN chmod +x /bootstrap.sh \
  /usr/local/sbin/stop-supervisor.sh \
  /opt/Artemis/Artemis.jar \
  && useradd -ms /bin/bash artemis

VOLUME ["/opt/Artemis/config"]
VOLUME ["/opt/Artemis/data"]
EXPOSE 8080

CMD exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
