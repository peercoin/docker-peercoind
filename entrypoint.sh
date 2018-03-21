#!/bin/bash
set -e

if [[ ! -s "$PPC_DATA/peercoin.conf" ]]; then
	cat <<-EOF > "$PPC_DATA/peercoin.conf"
	rpcallowip=::/0
	rpcpassword=${RPC_PASSWORD}
	rpcuser=${RPC_USER}
	EOF
	chown sunny:sunny "$PPC_DATA/peercoin.conf"
fi

if [[ "$1" == "peercoin-cli" || "$1" == "peercoind" || "$1" == "ppcoind" ]]; then

	exec gosu sunny "$@"
fi

exec "$@"