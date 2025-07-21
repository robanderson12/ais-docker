-- This database should already be created by POSTGRES_DB env var,
-- but we'll ensure it exists
\c ais_pg_hub_metastore_db;

-- Grant all privileges
GRANT ALL PRIVILEGES ON DATABASE ais_pg_hub_metastore_db TO ais;
GRANT ALL PRIVILEGES ON SCHEMA public TO ais;