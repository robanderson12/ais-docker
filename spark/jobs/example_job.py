from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("AIS Example Job") \
    .getOrCreate()

data = [("Alice", 34), ("Bob", 45), ("Charlie", 29)]
df = spark.createDataFrame(data, ["name", "age"])
df.show()

spark.stop()