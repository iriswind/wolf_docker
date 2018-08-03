FROM postgres:10
ENV PGDATA /var/lib/pgsql/10/data/
ENV POSTGRES_DB wolf
COPY db.sql /docker-entrypoint-initdb.d/
COPY wolf.sql /docker-entrypoint-initdb.d/