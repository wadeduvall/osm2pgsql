#!/bin/sh

if [ ! -f "/root/.pgpass" ]; then
    echo "postgis:5432:$POSTGRES_DB:$POSTGRES_USER:$POSTGRES_PASSWORD" > /root/.pgpass
    chmod 0600 /root/.pgpass
fi

if [ ! -f /data/data.osm.pbf ] && [ -z "$PBF" ]; then
    echo "WARNING: No import file or URL specified, please mount the pbf file
    to /data/data.osm.pbf or specify a URL with \$PBF"
fi

if [ -n "$PBF" ]; then
    wget -nv "$PBF" -O /data/data.osm.pbf
    
    if [ -n "$POLY" ]; then
        wget -nv "$POLY" -O /data/data.poly
    fi
fi

if [ -f /data/data.poly ]; then
    cp /data/data.poly /var/lib/mod_tile/data.poly
fi

if [ "$IMPORT" = true ]; then
    echo "Importing"
    osm2pgsql -H postgis -U $POSTGRES_USER -d $POSTGRES_DB \
    --create --slim -G --hstore \
    --tag-transform-script /openstreetmap-carto/openstreetmap-carto.lua \
    --number-processes ${THREADS:-4} ${OSM2PGSQL_EXTRA_ARGS} \
    -S /openstreetmap-carto/openstreetmap-carto.style \
    /data/data.osm.pbf

    touch /var/lib/mod_tile/planet-import-complete
elif [ "$UPDATE" = true ]; then
    echo "Updating"
    rm -rf /var/lib/mod_tile/ajt
    osm2pgsql -H postgis -U $POSTGRES_USER -d $POSTGRES_DB \
    --append --slim -G --hstore \
    --tag-transform-script /openstreetmap-carto/openstreetmap-carto.lua \
    --number-processes ${THREADS:-4} ${OSM2PGSQL_EXTRA_ARGS} \
    -S /openstreetmap-carto/openstreetmap-carto.style \
    /data/data.osm.pbf
fi

cd /openstreetmap-carto/
psql -h postgis -U $POSTGRES_USER -d $POSTGRES_DB -f indexes.sql
scripts/get-external-data.py -H postgis -U $POSTGRES_USER -d $POSTGRES_DB -D /data
scripts/get-fonts.sh
