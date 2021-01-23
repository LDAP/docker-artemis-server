#!/bin/bash

cd /opt/Artemis

cp -n -a /defaults/Artemis/. config/
chown -R artemis:artemis config data

# Allow waiting for other services
if [ -n "${WAIT_FOR}" ]; then
  hosts_ports=$(echo $WAIT_FOR | tr "," "\n" | tr -d "\"")
  for host_port in $hosts_ports
  do
    IFS=':' read -r -a host_port_split <<< "$host_port"
    until nc -z -w30 ${host_port_split[0]} ${host_port_split[1]}
    do
      echo "Waiting for $host_port"
      sleep 5
    done
  done
fi

echo "Starting application..."
exec gosu artemis java \
  -Djdk.tls.ephemeralDHKeySize=2048 \
  -DLC_CTYPE=UTF-8 \
  -Dfile.encoding=UTF-8 \
  -Dsun.jnu.encoding=UTF-8 \
  -Djava.security.egd=file:/dev/./urandom \
  -Xmx2048m \
  --add-modules java.se \
  --add-exports java.base/jdk.internal.ref=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED \
  --add-opens java.base/java.nio=ALL-UNNAMED \
  --add-opens java.base/sun.nio.ch=ALL-UNNAMED \
  --add-opens java.management/sun.management=ALL-UNNAMED \
  --add-opens jdk.management/com.sun.management.internal=ALL-UNNAMED \
  -jar Artemis.jar \
  --spring.profiles.active=$PROFILES
