FROM bitnami/spark:3.3.1

# Switch to root user to install dependencies
USER root

# Install curl and Hadoop client libraries
RUN install_packages curl

# Create directory for custom jars
RUN mkdir -p /opt/spark/jars

# Download Iceberg Spark runtime JAR
RUN curl -L -o /opt/spark/jars/iceberg-spark3-runtime.jar \
    https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.3_2.12/1.2.1/iceberg-spark-runtime-3.3_2.12-1.2.1.jar

# Download Hive Metastore client JARs
RUN curl -L -o /opt/spark/jars/hive-metastore.jar \
    https://repo1.maven.org/maven2/org/apache/hive/hive-metastore/3.1.2/hive-metastore-3.1.2.jar && \
    curl -L -o /opt/spark/jars/hive-exec.jar \
    https://repo1.maven.org/maven2/org/apache/hive/hive-exec/3.1.2/hive-exec-3.1.2.jar && \
    curl -L -o /opt/spark/jars/hadoop-common.jar \
    https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/3.3.1/hadoop-common-3.3.1.jar

# Configure Spark to use Hive Metastore
ENV SPARK_CONF_DIR=/opt/bitnami/spark/conf
COPY spark-defaults.conf $SPARK_CONF_DIR/

# Reset to non-root user
USER 1001