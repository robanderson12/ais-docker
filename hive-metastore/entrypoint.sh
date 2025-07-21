#!/bin/bash
set -e

# Wait for PostgreSQL
echo "Waiting for PostgreSQL..."
while ! nc -z postgres 5432; do
  sleep 1
done

# Initialize schema only if needed
cd $HIVE_HOME
if ! bin/schematool -dbType postgres -info 2>/dev/null | grep -q "schemaTool completed"; then
    echo "Initializing schema..."
    bin/schematool -dbType postgres -initSchema
fi

# Start metastore
exec bin/hive --service metastore
