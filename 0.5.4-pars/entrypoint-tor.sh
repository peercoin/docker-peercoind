#!/bin/sh
set -e

tor -f /etc/tor/torrc &
export HOSTNAME=$(cat /var/lib/tor/ppcoin-service/hostname)

./entrypoint.sh "$1"

