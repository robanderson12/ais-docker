# hive-metastore/Dockerfile
FROM apache/hive:3.1.3

# become root just for the patch
USER root

# Remove the three “SET statement_timeout …” lines that Postgres <15 rejects
RUN set -eux; \
    SCHEMA=/opt/hive/scripts/metastore/upgrade/postgres/hive-schema-3.1.0.postgres.sql; \
    chmod u+w "$SCHEMA"; \
    cp "$SCHEMA" "${SCHEMA}.orig"; \
    grep -v -i "statement_timeout" "${SCHEMA}.orig" > "$SCHEMA"

# return to the default hive user
USER hive