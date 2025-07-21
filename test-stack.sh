#!/bin/bash

echo "=== Testing AIS Docker Stack ==="
echo ""

# Function to check service
check_service() {
    SERVICE=$1
    echo -n "Checking $SERVICE... "
    if docker-compose ps | grep -q "${SERVICE}.*Up"; then
        echo "✅ Running"
        return 0
    else
        echo "❌ Not running"
        return 1
    fi
}

# 1. Check all services
echo "1. Service Status:"
check_service "postgres"
check_service "minio"
check_service "hive-metastore"
check_service "trino"
check_service "spark"
check_service "ais-core"
echo ""

# 2. Test PostgreSQL
echo "2. Testing PostgreSQL..."
docker-compose exec -T postgres psql -U ais -d ais_pg_hub_metastore_db -c "SELECT COUNT(*) as table_count FROM information_schema.tables WHERE table_schema='public';" 2>/dev/null
echo ""

# 3. Test MinIO
echo "3. Testing MinIO..."
docker run --rm --network=ais-docker_default \
  minio/mc alias set myminio http://minio:9000 minioadmin minioadmin 2>/dev/null
docker run --rm --network=ais-docker_default \
  minio/mc admin info myminio 2>/dev/null | grep -E "Uptime|Version"
echo ""

# 4. Test Hive Metastore
echo "4. Testing Hive Metastore..."
docker-compose exec -T hive-metastore hive --service cli -e "SHOW DATABASES;" 2>/dev/null
echo ""

# 5. Test Trino
echo "5. Testing Trino..."
docker-compose exec -T trino trino --execute "SHOW CATALOGS;" 2>/dev/null
echo ""

# 6. Test data flow
echo "6. Testing Data Flow..."
echo "Creating test data..."

# Create CSV data
cat > /tmp/test-data.csv << EOF
id,name,value
1,Alice,100
2,Bob,200
3,Charlie,300
EOF

# Upload to MinIO
docker run --rm -v /tmp:/data --network=ais-docker_default \
  minio/mc cp /data/test-data.csv myminio/test-bucket/ 2>/dev/null

# Create external table in Trino
docker-compose exec -T trino trino --execute "
CREATE SCHEMA IF NOT EXISTS hive.test_schema;
CREATE TABLE IF NOT EXISTS hive.test_schema.test_external (
    id INT,
    name VARCHAR,
    value INT
) WITH (
    external_location = 's3a://test-bucket/',
    format = 'CSV',
    skip_header_line_count = 1
);" 2>/dev/null

# Query the data
echo "Querying test data through Trino:"
docker-compose exec -T trino trino --execute "SELECT * FROM hive.test_schema.test_external;" 2>/dev/null

echo ""
echo "=== Test Complete ==="