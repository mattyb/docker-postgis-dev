#!/bin/bash

psql -d postgis -c "alter user postgres password 'postgres'"
psql -d postgis -c "update tiger.loader_platform set declare_sect='TMPDIR=\"\${staging_fold}/temp/\"
UNZIPTOOL=unzip
WGETTOOL=\"/usr/bin/wget\"
export PGBIN=/usr/lib/postgresql/9.3/bin
export PGPORT=5432
export PGHOST=localhost
export PGUSER=postgres
export PGPASSWORD=postgres
export PGDATABASE=postgis
PSQL=\${PGBIN}/psql
SHP2PGSQL=\${PGBIN}/shp2pgsql
cd \${staging_fold}'
WHERE os ='sh'"

psql -d postgis -zAt -c "SELECT loader_generate_nation_script('sh') AS result;" > ~/loader_script_ct.sh
psql -d postgis -zAt -c "SELECT loader_generate_script(ARRAY['CT'], 'sh') AS result;" >> ~/loader_script_ct.sh
chmod +x ~/loader_script_ct.sh
~/loader_script_ct.sh
psql -d postgis -c "SELECT geocode('300 Capitol Avenue, Hartford, CT 06106') AS g;"
psql -d postgis -c "SELECT geocode('110 river street, milford, ct 06106') AS g;"
