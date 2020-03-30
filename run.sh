osm2pgsql -H postgis -U renderer -W renderer -d gis \
--create --slim -G --hstore \
--tag-transform-script /openstreetmap-carto/openstreetmap-carto.lua \
--number-processes ${THREADS:-4} ${OSM2PGSQL_EXTRA_ARGS} \
-S /openstreetmap-carto/openstreetmap-carto.style \
/data.osm.pbf
