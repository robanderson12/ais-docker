from pyspark.sql import SparkSession

# Initialize Spark
spark = SparkSession.builder \
    .appName("Test Iceberg") \
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.iceberg.spark.SparkSessionCatalog") \
    .getOrCreate()

# Create test data
data = [(1, "Test1"), (2, "Test2")]
df = spark.createDataFrame(data, ["id", "name"])

# Show data
print("Test DataFrame:")
df.show()

spark.stop()