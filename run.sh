if [ ! -f "/root/.pgpass" ]; then
    echo "postgis:5432:$POSTGRES_DB:$POSTGRES_USER:$POSTGRES_PASSWORD" > /root/.pgpass
    chmod 0600 /root/.pgpass
fi

osm2pgsql -H postgis -U $POSTGRES_USER -d $POSTGRES_DB \
--create --slim -G --hstore \
--tag-transform-script /openstreetmap-carto/openstreetmap-carto.lua \
--number-processes ${THREADS:-4} ${OSM2PGSQL_EXTRA_ARGS} \
-S /openstreetmap-carto/openstreetmap-carto.style \
/data.osm.pbf
