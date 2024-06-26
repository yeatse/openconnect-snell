#!/bin/sh

launch() {
  if [ -z "$PSK" ]; then
    PSK=`hexdump -n 16 -e '4/4 "%08x" 1 "\n"' /dev/urandom`
  fi
  
  (echo "$OC_PASSWD"; echo "${OC_AUTH_CODE}") | openconnect -v -b --user="${OC_USER}" --authgroup="${OC_AUTH_GROUP}" ${OC_ADDITIONAL_OPTIONS} "${OC_HOST}" --passwd-on-stdin

  cat > snell.conf <<EOF
[snell-server]
listen = ${SERVER_HOST}:${SERVER_PORT}
psk = ${PSK}
ipv6 = false
EOF

  cat snell.conf
  sleep 5 && snell-server -c snell.conf
}

if [ -z "$@" ]; then
  launch
else
  exec "$@"
fi
