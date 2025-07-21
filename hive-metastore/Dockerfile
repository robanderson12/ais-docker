FROM openjdk:8-jre-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl netcat postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Set Hive version
ENV HIVE_VERSION=3.1.3
ENV HIVE_HOME=/opt/hive
ENV PATH=$HIVE_HOME/bin:$PATH

# Download and install Hive
RUN curl -L https://downloads.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz | \
    tar -xz -C /opt && \
    mv /opt/apache-hive-${HIVE_VERSION}-bin $HIVE_HOME

# Download PostgreSQL JDBC driver
RUN curl -L https://jdbc.postgresql.org/download/postgresql-42.5.4.jar \
    -o $HIVE_HOME/lib/postgresql-42.5.4.jar

# Configure Hive for PostgreSQL
COPY hive-site.xml $HIVE_HOME/conf/

# Create startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9083

ENTRYPOINT ["/entrypoint.sh"]