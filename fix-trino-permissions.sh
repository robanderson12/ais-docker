#!/bin/bash

echo "Fixing Trino permissions issue..."

# Stop Trino
docker-compose stop trino

# Create all necessary directories
mkdir -p ./trino/etc/catalog
mkdir -p ./trino/data

# Create config.properties
cat > ./trino/etc/config.properties << 'EOF'
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=8080
discovery.uri=http://localhost:8080
EOF

# Create node.properties with temp directory
cat > ./trino/etc/node.properties << 'EOF'
node.environment=docker
node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
node.data-dir=/tmp/trino-data
EOF

# Create jvm.config
cat > ./trino/etc/jvm.config << 'EOF'
-server
-Xmx1G
-XX:+UseG1GC
-XX:G1HeapRegionSize=32M
-XX:+UseGCOverheadLimit
-XX:+ExplicitGCInvokesConcurrent
-XX:+HeapDumpOnOutOfMemoryError
-XX:+ExitOnOutOfMemoryError
-Djdk.attach.allowAttachSelf=true
EOF

# Create log.properties
cat > ./trino/etc/log.properties << 'EOF'
io.trino=INFO
EOF

# Create hive catalog
cat > ./trino/etc/catalog/hive.properties << 'EOF'
connector.name=hive
hive.metastore.uri=thrift://hive-metastore:9083
hive.allow-drop-table=true
hive.s3.endpoint=http://minio:9000
hive.s3.access-key=minioadmin
hive.s3.secret-key=minioadmin
hive.s3.path-style-access=true
EOF

# Set permissions
chmod -R 755 ./trino

echo "Starting Trino..."
docker-compose up -d trino

echo "Waiting for Trino to start..."
sleep 10

# Check if it's running
docker-compose ps trino

# Show logs
docker-compose logs --tail=20 trino