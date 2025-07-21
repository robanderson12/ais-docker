-- Show catalogs
SHOW CATALOGS;

-- Show schemas in hive catalog (if configured)
SHOW SCHEMAS FROM hive;

-- Create a test table
CREATE SCHEMA IF NOT EXISTS hive.test_schema;

CREATE TABLE IF NOT EXISTS hive.test_schema.test_table (
    id INT,
    name VARCHAR(100)
);

-- Insert test data
INSERT INTO hive.test_schema.test_table VALUES (1, 'test');

-- Query the data
SELECT * FROM hive.test_schema.test_table;
