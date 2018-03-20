#!/bin/bash
set -e

if [[ "$1" == "peercoin-cli" || "$1" == "peercoind" || "$1" == "ppcoind" ]]; then
	mkdir -p "$PPC_DATA"

	if [[ ! -s "$PPC_DATA/peercoin.conf" ]]; then
		cat <<-EOF > "$PPC_DATA/peercoin.conf"
		rpcallowip=::/0
		rpcpassword=${RPC_PASSWORD}
		rpcuser=${RPC_USER}
		EOF
		chown sunny:sunny "$PPC_DATA/peercoin.conf"
	fi

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R sunny "$PPC_DATA"
	ln -sfn "$PPC_DATA" /home/sunny/.peercoin
	chown -h sunny:sunny /home/sunny/.peercoin

	exec gosu sunny "$@"
fi

exec "$@"