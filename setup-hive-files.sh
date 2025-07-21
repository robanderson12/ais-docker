#!/bin/bash

echo "Setting up Hive Metastore files..."

# Create hive-metastore directory
mkdir -p ./hive-metastore

# Create hive-site.xml
cat > ./hive-metastore/hive-site.xml << 'EOF'
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:postgresql://postgres:5432/ais_pg_hub_metastore_db</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>org.postgresql.Driver</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>ais</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>aispassword</value>
    </property>
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/opt/hive/warehouse</value>
    </property>
    <property>
        <name>hive.metastore.schema.verification</name>
        <value>false</value>
    </property>
</configuration>
EOF

# Create entrypoint.sh
cat > ./hive-metastore/entrypoint.sh << 'EOF'
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
EOF

chmod +x ./hive-metastore/entrypoint.sh

echo "Files created successfully!"
ls -la ./hive-metastore/