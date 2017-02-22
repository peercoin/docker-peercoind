#!/bin/sh
set -e

tor -f /etc/tor/torrc &
#wait for tor to start
sleep 15
export HOSTNAME=$(cat /var/lib/tor/ppcoin-service/hostname)

#pass in hostname after variable set
./entrypoint.sh "$@" -externalip=${HOSTNAME}

