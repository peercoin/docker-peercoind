#!/bin/bash
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  	echo "$0: assuming arguments for peercoind"
  	set -- peercoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "peercoind" ] || [ "$1" = "peercoind" ]; then
	if [[ ! -s "$PPC_DATA/peercoin.conf" ]]; then
		cat <<-EOF > "$PPC_DATA/peercoin.conf"
		rpcallowip=::/0
		rpcpassword=${RPC_PASSWORD}
		rpcuser=${RPC_USER}
		EOF
		chown sunny:sunny "$PPC_DATA/peercoin.conf"
	fi
  	set -- "$@" -datadir="$PPC_DATA"
fi

if [ "$1" = "peercoind" ] || [ "$1" = "peercoin-cli" ] || [ "$1" = "ppcoind" ]; then
  	echo
  	exec gosu sunny "$@"
fi

exec "$@"