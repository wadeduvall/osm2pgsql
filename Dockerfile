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
    && rm -rf .git \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j $(nproc) \
    && make install \
    && rm -rf osm2pgsql

RUN wget -nv http://download.geofabrik.de/europe/luxembourg-latest.osm.pbf \
    -O /data.osm.pbf \
    && wget -nv http://download.geofabrik.de/europe/luxembourg.poly \
    -O /data.poly

RUN git clone git://github.com/gravitystorm/openstreetmap-carto \
    && cd openstreetmap-carto \
    && git checkout v5.0.0 \
    && rm -rf .git

COPY run.sh /

ENTRYPOINT ["/run.sh"]
