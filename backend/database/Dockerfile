FROM postgres:13-alpine

COPY schema.sql /docker-entrypoint-initdb.d/
COPY seed.sql /docker-entrypoint-initdb.d/

ENV POSTGRES_USER=user
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_DB=medical_db

EXPOSE 5432