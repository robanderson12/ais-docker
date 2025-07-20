-- Create metadata DB
CREATE DATABASE ais_pg_hub_metastore_db;

-- Create data DB
CREATE DATABASE ais_pg_hub_datastore_db;

-- Grant privileges
\c ais_pg_hub_metastore_db;
GRANT ALL PRIVILEGES ON DATABASE ais_pg_hub_metastore_db TO ais;

\c ais_pg_hub_datastore_db;
GRANT ALL PRIVILEGES ON DATABASE ais_pg_hub_datastore_db TO ais;