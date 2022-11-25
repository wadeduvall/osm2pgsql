FROM ubuntu:22.04

# Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive && apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
         git \
         wget \
         unzip \
         curl \
         postgresql-client \
         python3-psycopg2 \
         python3-yaml \
         gdal-bin \
         osm2pgsql

RUN git clone https://github.com/gravitystorm/openstreetmap-carto.git \
    && cd openstreetmap-carto \
    && rm -rf .git

COPY import.sh /import.sh
RUN chmod 0700 /import.sh
