# peercoin/peercoind

[![](https://images.microbadger.com/badges/image/peercoin/peercoind.svg)](https://microbadger.com/images/peercoin/peercoind "Size/Layers")

Peercoind docker image. There are two tags: `latest` - which provides classic peercoin binary built from github/peercoin repository.

## Supported tags and respective `Dockerfile` links

- `0.8.5` ([0.8.5/Dockerfile](https://github.com/peercoin/docker-peercoind/blob/master/0.8.5/Dockerfile))

## Usage
### How to use this image

It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to the `peercoind` binary:

```sh
$ docker run --name peercoind -d peercoin/peercoind \
  -rpcallowip=* \
  -rpcpassword=bar \
  -rpcuser=foo
```

Due to this you can use the same command to start the testnet container:

```sh
$ docker run --name testnet-peercoind -d peercoin/peercoind \
  -rpcallowip=* \
  -rpcpassword=bar \
  -rpcuser=foo \
  -testnet=1
```

By default, `peercoin` will run as as user `peercoin` for security reasons and store data in `/data`. If you'd like to customize where `peercoin` stores its data, you must use the `PPC_DATA` environment variable. The directory will be automatically created with the correct permissions for the user and `peercoin` automatically configured to use it.

```sh
$ docker run --env PPC_DATA=/var/lib/peercoin --name peercoind -d peercoin/peercoind
```

You can also mount a directory it in a volume under `/data` in case you want to access it on the host:

```sh
$ docker run -v /opt/peercoin:/data --name peercoind -d peercoin/peercoind
```
That will allow to access containers `/data` directory in `/opt/peercoin` on the host.


```sh
$ docker run -v ${PWD}/data:/data --name peercoind -d peercoin/peercoind
```
will mount current directory at `/data` in the container.

To map container RPC ports to localhost start container with following command:

```sh
$ docker run -p 9902:9902 --name peercoind -d peercoin/peercoind -rpcallowip=*
```
You may want to change the port that it is being mapped to if you already run a peercoin instance on the localhost.
For example: `-p 9999:9902` will map port 9902 from container to localhost:9999.

Now you will be able to `curl` the peercoin RPC in the container:

`curl --user foo:bar --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }'  -H 'content-type: text/plain;' localhost:9902/`

> {"result":{"chain":"main","blocks":457576,"headers":457576,"bestblockhash":"17a24a8073c8f6bc422fc4f6fe8c76da892d0693d0ad1aa499e4b9b2c047fe2b","difficulty":1710444103.933884,"mediantime":1571034759,"verificationprogress":0.9999997034325266,"initialblockdownload":false,"chainwork":"00000000000000000000000000000000000000000000000000336b3807456f56","size_on_disk":700956211,"pruned":false,"warnings":""},"error":null,"id":"curltest"}
