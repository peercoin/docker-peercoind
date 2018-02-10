FROM debian:stable-slim
LABEL maintainer.0="Peerchemist (@peerchemist)"

ENV GOSU_VERSION=1.10

# build
## dependencies
RUN apt-get update -y && apt-get install -y wget curl gnupg \ 
    && wget -nv https://download.opensuse.org/repositories/home:/peerchemist/Debian_9.0/Release.key -O Release.key \
    && apt-key add - < Release.key \
    && sh -c "echo 'deb http://ftp.gwdg.de/pub/opensuse/repositories/home:/peerchemist/Debian_9.0/ /' > /etc/apt/sources.list.d/peercoin-obs.list" \
    && apt-get update && apt-get install -y peercoind \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    ## gosu
    && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
    && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && useradd -r sunny

## container stuff
ENV PPC_DATA=/home/sunny/.ppcoin \
  PATH=/usr/local/bin/:$PATH
VOLUME ["/home/sunny/.ppcoin"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9901 9902 9903 9904
CMD ["peercoind"]
