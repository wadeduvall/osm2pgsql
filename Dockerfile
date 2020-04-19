FROM ubuntu:18.04

# Install dependencies
RUN apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
         git \
         wget \
         make \
         cmake \
         g++ \
         libboost-dev \
         libboost-system-dev \
         libboost-filesystem-dev \
         libexpat1-dev \
         zlib1g-dev \
         libbz2-dev \
         libpq-dev \
         libgeos-dev \
         libgeos++-dev \
         libproj-dev \
         lua5.2 \
         liblua5.2-dev

# Build and insteall osm2pgsql, then clean up
RUN git clone git://github.com/openstreetmap/osm2pgsql.git \
    && cd osm2pgsql \
    && git checkout 1.2.1 \
    && rm -rf .git \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j $(nproc) \
    && make install \
    && cd / \
    && rm -rf osm2pgsql

RUN git clone git://github.com/gravitystorm/openstreetmap-carto \
    && cd openstreetmap-carto \
    && git checkout v5.0.0 \
    && rm -rf .git

COPY import.sh /import.sh
RUN chmod 0700 /import.sh
