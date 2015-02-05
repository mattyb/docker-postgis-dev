# PostgreSQL

FROM ubuntu:trusty
MAINTAINER David Zumbrunnen <zumbrunnen@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install language-pack-en python-software-properties \
      software-properties-common postgresql-common postgresql-9.3 postgresql-client-9.3 \
      postgresql-contrib-9.3 \
      build-essential postgresql-server-dev-9.3 libpq-dev autoconf libtool \
      dblatex imagemagick xsltproc libxml2-dev libcunit1 libcunit1-doc libcunit1-dev \
	  proj-bin libproj-dev libgeos-dev libgdal-dev libgdal1-dev libgdal-perl libgdal-java libgdal1h libjson-c-dev \
      && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN apt-get -y install libpcre3-dev
RUN apt-get -y install subversion

ENV LANG en_US.utf8

# setup postgres 
USER postgres
RUN  pg_dropcluster --stop 9.3 main && \
      pg_createcluster --start -e UTF-8 9.3 main && \
      psql --command "CREATE USER postgis WITH SUPERUSER PASSWORD 'postgis';" && \
      createdb -O postgis postgis && \
      /usr/lib/postgresql/9.3/bin/pg_ctl stop -D /var/lib/postgresql/9.3/main

ADD postgresql.conf /var/lib/postgresql/9.3/main/postgresql.conf
ADD pg_hba.conf /var/lib/postgresql/9.3/main/pg_hba.conf

# VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
EXPOSE 5432

# compile & install postgis
USER root
ADD trunk /postgis/trunk
RUN chmod -R a+w /postgis/trunk

ENV DEBIAN_FRONTEND newt

RUN cd /postgis/trunk && svn upgrade && ./autogen.sh && ./configure && make && make install

# create postgis databases
USER postgres
RUN /usr/lib/postgresql/9.3/bin/pg_ctl start -D /var/lib/postgresql/9.3/main && \
    psql -d postgis --command "CREATE EXTENSION postgis;" && \
    psql -d postgis --command "CREATE EXTENSION postgis_topology;" && \
    psql -d postgis --command "CREATE EXTENSION fuzzystrmatch;" && \
    psql -d postgis --command "CREATE EXTENSION postgis_tiger_geocoder;" && \
    psql -d postgis --command "SELECT na.address, na.streetname,na.streettypeabbrev, na.zip FROM normalize_address('1 Devonshire Place, Boston, MA 02109') AS na;" && \
    /usr/lib/postgresql/9.3/bin/pg_ctl stop -w -D /var/lib/postgresql/9.3/main 

CMD /usr/lib/postgresql/9.3/bin/pg_ctl start -D /var/lib/postgresql/9.3/main && /bin/bash

