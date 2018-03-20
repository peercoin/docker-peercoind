FROM phusion/baseimage
LABEL maintainer.0="Peerchemist (@peerchemist)"

ENV PPC_VERSION=0.6.2ppc
ENV PPC_SHA256 d64a8fdcd874d2e211f5dd3002e187769b3ec656f985f538ea0510f1b58ac2b6
ENV GOSU_VERSION=1.10
ENV RPC_USER = "sunny"
ENV RPC_PASSWORD = "oxrubid7"

RUN groupadd -r sunny && useradd -r -m -g sunny sunny

# build
## dependencies
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y curl gnupg dirmngr ca-certificates build-essential libssl-dev libdb-dev libdb++-dev \
    libboost-dev libboost-program-options-dev libboost-filesystem-dev libboost-system-dev libboost-test-dev libboost-thread-dev libboost-chrono-dev \
    autotools-dev pkg-config libtool automake autoconf \
    ## gosu
    && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
    && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    ## peercoind
    && curl -SLO4 https://github.com/ppcoin/ppcoin/archive/v${PPC_VERSION}.tar.gz \
    && tar xf v${PPC_VERSION}.tar.gz \
    && echo "$PPC_SHA256 v${PPC_VERSION}.tar.gz" | sha256sum -c - \
    && cd peercoin-${PPC_VERSION} \
    ## make peercoind
    && ./autogen.sh \ 
    && ./configure --with-gui=no --with-incompatible-bdb --host=x86_64-pc-linux-gnu --target=x86_64-pc-linux-gnu --build=x86_64-pc-linux-gnu \
    && make \
    && install -Dm755 "src/peercoind" "/usr/bin/" \
    && install -Dm755 "src/peercoin-cli" "/usr/bin/" \
    && ln -s /usr/local/bin/peercoind /usr/local/bin/ppcoind \
    ## cleanup
    && cd .. && rm v${PPC_VERSION}.tar.gz && rm -r peercoin-${PPC_VERSION} \
    && apt-get remove -y --purge curl ca-certificates build-essential libssl-dev libdb++-dev \
    libboost-program-options-dev libboost-filesystem-dev libboost-system-dev libboost-thread-dev \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# create data directory
ENV PPC_DATA /data
RUN mkdir "$PPC_DATA" \
	&& chown -R sunny:sunny "$PPC_DATA" \
	&& ln -sfn "$PPC_DATA" /home/sunny/.peercoin \
	&& chown -h sunny:sunny /home/sunny/.peercoin
VOLUME /data

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9901 9902 9903 9904
CMD ["/usr/bin/peercoind"]
