# Build stage for BerkeleyDB
FROM alpine as berkeleydb

RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
RUN apk --no-cache add build-base
RUN apk --no-cache add openssl

ENV BERKELEYDB_VERSION=db-4.8.30.NC
ENV BERKELEYDB_PREFIX=/opt/berkleydb

RUN wget -q https://download.oracle.com/berkeley-db/${BERKELEYDB_VERSION}.tar.gz
RUN tar -xzf *.tar.gz
RUN sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i ${BERKELEYDB_VERSION}/dbinc/atomic.h
RUN mkdir -p ${BERKELEYDB_PREFIX}

WORKDIR /${BERKELEYDB_VERSION}/build_unix

RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BERKELEYDB_PREFIX}
RUN make -j4
RUN make install
RUN rm -rf ${BERKELEYDB_PREFIX}/docs

# Build stage for Peercoind
FROM alpine as peercoin-build

COPY --from=berkeleydb /opt /opt

RUN apk --no-cache add autoconf \
    automake \
    boost-dev \
    build-base \
    ## chrpath \        Was in bticoin one, doesn't appear to be needed
    ## file \           Was in bticoin one, doesn't appear to be needed
    ## libevent-dev \   Was in bticoin one, doesn't appear to be needed
    openssl \
    openssl-dev \
    libtool \
    # libexecinfo-dev \ Needed for execinfo/backtrace in src/util.cpp but still doesn't work
    linux-headers 

ENV PEERCOIN_VERSION=0.6.3 \
    PEERCOIN_SHA=bf48a38760d84804e406fc71461c6148c4764a9f576e3f968ab7a22e064714ca \
    PEERCOIN_PREFIX=/opt/peercoin

RUN wget -q -O peercoin.tar.gz https://github.com/peercoin/peercoin/archive/v${PEERCOIN_VERSION}ppc.tar.gz \
    && echo "${PEERCOIN_SHA}  peercoin.tar.gz" | sha256sum -c - 

RUN tar -xzf peercoin.tar.gz

WORKDIR /peercoin-${PEERCOIN_VERSION}ppc

RUN sed -i '/AC_PREREQ/a\ARFLAGS=cr' configure.ac \
    && sed -i 's:sys/fcntl.h:fcntl.h:' src/compat.h
# ./configure can't find berkley db unless we do this
RUN ln -s /opt/berkleydb /usr/include/db4.8 \
    && ln -s /opt/berkleydb/include/* /usr/include  \
    && ln -s /opt/berkleydb/lib/* /usr/lib

# Alpine doesn't contain backtrace so we nuke references to it, even including libexecinfo-dev
RUN sed -i 's/.*backtrace.*//g' src/util.cpp \
    && sed -i 's/.*execinfo.h.*//g' src/util.cpp

RUN ./autogen.sh
RUN ./configure \
    --prefix=${PEERCOIN_PREFIX} \
    --mandir=/usr/share/man \
    --disable-tests \
    --disable-ccache \
    --with-gui=no

RUN make
RUN make install
RUN strip ${PEERCOIN_PREFIX}/bin/peercoin-cli
RUN strip ${PEERCOIN_PREFIX}/bin/peercoind

# Build stage for compiled artifacts
FROM alpine

RUN adduser -S peercoin && \
  apk --no-cache add \
    boost \
    boost-program_options \
    openssl \
    su-exec \
    bash

ENV PPC_DATA=/data
ENV PEERCOIN_PREFIX=/opt/peercoin
ENV PATH=${PEERCOIN_PREFIX}/bin:$PATH
ENV RPC_PASSWORD=ppcpass
ENV RPC_USER=ppcuser

COPY --from=peercoin-build /opt /opt
COPY docker-entrypoint.sh /entrypoint.sh

VOLUME [${PPC_DATA}]

EXPOSE 9901 9902 9903 9904

ENTRYPOINT ["/entrypoint.sh"]

CMD ["peercoind"]