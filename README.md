# peerchemist/peercoind
Peercoind docker image.

## Supported tags and respective `Dockerfile` links
- `0.5.4` ([0.54/Dockerfile](https://github.com/peerchemist/docker-peercoind/blob/master/0.5.4/Dockerfile))
- `0.5.4-pars` ([0.54-pars/Dockerfile](https://github.com/peerchemist/docker-peercoind/blob/master/0.5.4-pars/Dockerfile))

## Usage
### How to use this image
It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to the `ppcoind` binary:

```sh
$ docker run --rm -it peerchemist/docker-peercoind \
  -rpcallowip=172.17.0.0/16 \
  -rpcpassword=bar \
  -rpcuser=foo
```

By default, `ppcoind` will run as as user `sunny` for security reasons and with its default data dir (`~/.ppcoind`). If you'd like to customize where `ppcoind` stores its data, you must use the `PPC_DATA` environment variable. The directory will be automatically created with the correct permissions for the `sunny` user and `ppcoind` automatically configured to use it.

```sh
$ docker run --env PPC_DATA=/var/lib/peercoin --rm -it peerchemist/docker-peercoind
```

You can also mount a directory it in a volume under `/home/sunny/.ppcoind` in case you want to access it on the host:

```sh
$ docker run -v /opt/peercoin:/home/sunny/.ppcoin -it --rm peerchemist/docker-peercoind
```
That will allow to access containers `~/.ppcoin` directory in `/opt/peercoin` on the host.


```sh
$ docker run -v ${PWD}/data:/home/sunny/.ppcoin -it --rm peerchemist/docker-peercoind
```
will mount current directiory in containers `~/.ppcoin`

