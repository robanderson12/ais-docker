FROM apache/hive:3.1.3

USER root   # <-- elevate just for the patch
RUN set -eux; \
    SCHEMA=/opt/hive/scripts/metastore/upgrade/postgres/hive-schema-3.1.0.postgres.sql; \
    chmod u+w "$SCHEMA"; \
    cp "$SCHEMA" "${SCHEMA}.orig"; \
    grep -v -i "statement_timeout" "${SCHEMA}.orig" > "$SCHEMA"

USER hive   # <-- restore original user

CMD ["/opt/hive/bin/hive","--service","metastore"]