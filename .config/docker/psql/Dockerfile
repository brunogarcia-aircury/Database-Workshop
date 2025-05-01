FROM postgres:17.3

RUN apt-get update

RUN apt-get install -y postgresql-17-pgtap

COPY init.sql /docker-entrypoint-initdb.d/
COPY postgresql.conf /etc/postgresql/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432