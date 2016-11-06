#!/usr/bin/env sh
set -e

[ -z "$1" ] && echo "syntax is ./enter.sh 1 or ./enter.sh 2" && exit 1

docker exec -it testnet_localtestnet${1}_1 /bin/bash
