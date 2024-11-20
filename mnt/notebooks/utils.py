import pyspark
from pyspark.sql import SparkSession
import os


AWS_ACCESS_KEY = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
S3_ENDPOINT = os.getenv("S3_ENDPOINT")

def get_spark_session(spark_app, bucket):

  MASTER = "spark://spark-master:7077"
  jar_packages = [
    "org.apache.iceberg:iceberg-spark-runtime-3.5_2.12-1.6.1",
    "org.projectnessie.nessie-integrations:nessie-spark-extensions-3.5_2.12-0.99.0",
    "software.amazon.awssdk:bundle:2.28.13",
    "software.amazon.awssdk:url-connection-client:2.28.13",
    "org.apache.iceberg:iceberg-aws-bundle-1.6.1"
  ]

  spark_extensions = [
    "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions",
      #"org.projectnessie.spark.extensions.NessieSparkSessionExtensions"
  ]

  conf = (
    pyspark.SparkConf()
    .setAppName('iceberg')
    .set('spark.jars.packages', ','.join(jar_packages))
    .set('spark.sql.extensions', ','.join(spark_extensions))
    .set("spark.executor.memory", "1g")
    .set("spark.executor.cores", "1")
    .set("spark.executor.instances", "1")
    .set("spark.driver.memory", "1g")
    .set('spark.sql.catalog.nessie', "org.apache.iceberg.spark.SparkCatalog")
    .set('spark.sql.catalog.nessie.s3.path-style-access', 'true')
    .set('spark.sql.catalog.nessie.s3.endpoint', S3_ENDPOINT)
    .set('spark.sql.catalog.nessie.warehouse', f's3://{bucket}')
    .set('spark.sql.catalog.nessie.catalog-impl', 'org.apache.iceberg.nessie.NessieCatalog')
    .set('spark.sql.catalog.nessie.io-impl', 'org.apache.iceberg.aws.s3.S3FileIO')
    .set('spark.sql.catalog.nessie.uri', "http://nessie:19120/api/v2")
    .set('spark.sql.catalog.nessie.ref', 'main')
    .set('spark.sql.catalog.nessie.authentication.type', 'NONE')
    .set('spark.sql.catalog.nessie.cache-enabled', 'false')
    .set('spark.hadoop.fs.s3a.access.key', AWS_ACCESS_KEY)
    .set('spark.hadoop.fs.s3a.secret.key', AWS_SECRET_KEY)
    .set("spark.hadoop.fs.s3a.endpoint", S3_ENDPOINT)
    #
    # .set("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")

  )
  spark = SparkSession.builder.config(conf=conf).getOrCreate()
  spark.sparkContext.setLogLevel("ERROR")
  return spark