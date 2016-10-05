# peerchemist/peercoind

[![](https://images.microbadger.com/badges/image/peerchemist/peercoind.svg)](https://microbadger.com/images/peerchemist/peercoind "Size/Layers")

[![tip for next commit](https://peer4commit.com/projects/189.svg)](https://peer4commit.com/projects/189)

Peercoind docker image. There are two tags: `latest` - which provides classic ppcoind binary built from github/ppcoin repository.
Other tag is `pars` which provides modified client by @hrobeers.

## Supported tags and respective `Dockerfile` links
- `0.5.4` ([0.54/Dockerfile](https://github.com/peerchemist/docker-peercoind/blob/master/0.5.4/Dockerfile))
- `0.5.4-pars` ([0.54-pars/Dockerfile](https://github.com/peerchemist/docker-peercoind/blob/master/0.5.4-pars/Dockerfile))

## Usage
### How to use this image

It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to the `ppcoind` binary:

```sh
$ docker run --name peercoind -d peerchemist/peercoind \
  -rpcallowip=* \
  -rpcpassword=bar \
  -rpcuser=foo
```

Due to this you can use the same command to start the testnet container:

```sh
$ docker run --name ppctestnet -d peerchemist/peercoind \
  -rpcallowip=* \
  -rpcpassword=bar \
  -rpcuser=foo \
  -testnet=1
```

By default, `ppcoind` will run as as user `sunny` for security reasons and with its default data dir (`~/.ppcoind`). If you'd like to customize where `ppcoind` stores its data, you must use the `PPC_DATA` environment variable. The directory will be automatically created with the correct permissions for the `sunny` user and `ppcoind` automatically configured to use it.

```sh
$ docker run --env PPC_DATA=/var/lib/peercoin --name peercoind -d peerchemist/peercoind
```

You can also mount a directory it in a volume under `/home/sunny/.ppcoind` in case you want to access it on the host:

```sh
$ docker run -v /opt/peercoin:/home/sunny/.ppcoin --name peercoind -d peerchemist/peercoind
```
That will allow to access containers `~/.ppcoin` directory in `/opt/peercoin` on the host.


```sh
$ docker run -v ${PWD}/data:/home/sunny/.ppcoin --name peercoind -d peerchemist/peercoind
```
will mount current directiory in containers `~/.ppcoin`


```sh
$ docker run -v /opt/pars:/home/sunny/.ppcoin --name peercoind -d peerchemist/peercoind:pars
```
will pull a pars image and set it up in `/opt/pars`.


To map container RPC ports to localhost start container with following command:

```sh
$ docker run -v /opt/pars:/home/sunny/.ppcoin -p 9902:9902 --name peercoind -d peerchemist/peercoind:pars -rpcallowip=*
```
You may want to change the port that it is being maped to if you already run a ppcoind instance on the localhost.
For example: `-p 9999:9902` will map port 9902 from container to localhost:9999.

Now you will be able to `curl` the ppcoind RPC in the container:

`curl --user bitcoin:password --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getinfo", "params": [] }'  -H 'cont
ent-type: text/plain;' localhost:9902/`

> {"result":{"version":"PARS:0.5.4(v0.5.4.0-ge520ebd)","protocolversion":60006,"walletversion":60000,"balance":0.00000000,"newmint":0.00000000,"stake":0.00000000,"blo
cks":110392,"moneysupply":21378261.50852500,"connections":8,"proxy":"","ip":"83.161.111.125","difficulty":150011848.56944141,"testnet":false,"keypoololdest":1475227
858,"keypoolsize":101,"paytxfee":0.01000000,"errors":"WARNING: Checkpoint is too old. Wait for block chain to download, or notify developers of the issue."},"error"
:null,"id":"curltest"}
