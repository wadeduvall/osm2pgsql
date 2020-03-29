FROM ubuntu:18.04

# Install dependencies
RUN apt update \
    && apt upgrade \
    && apt install -y --no-install-recommends \
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

RUN git clone git://github.com/openstreetmap/osm2pgsql.git \
    && cd osm2pgsql \
    && rm -rf .git \
    && mkdir build \
    && cmake .. \
    && make -j $(nproc) \
    && make install \
    && rm -rf osm2pgsql
