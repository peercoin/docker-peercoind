#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for ppcoind"

  set -- ppcoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "ppcoind" ]; then
  mkdir -p "$PPC_DATA"
  chmod 700 "$PPC_DATA"
  chown -R sunny "$PPC_DATA"

  echo "$0: setting data directory to $PPC_DATA"

  set -- "$@" -datadir="$PPC_DATA"
fi

if [ ! -f $PPC_DATA/ppcoin.conf ]; then
  	cat <<-EOF > "$PPC_DATA/ppcoin.conf"
      rpcpassword=${PPCCOIN_RPC_PASSWORD:-password}
      rpcuser=${PPCCOIN_RPC_USER:-bitcoin}
		EOF
fi

if [ "$1" = "ppcoind" ]; then
  echo
  exec gosu sunny "$@"
fi

echo
exec "$@"
