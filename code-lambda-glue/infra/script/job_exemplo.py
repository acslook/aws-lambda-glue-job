import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node Amazon S3
AmazonS3_node1710895724662 = glueContext.create_dynamic_frame.from_options(format_options={"quoteChar": "\"", "withHeader": True, "separator": ",", "optimizePerformance": False}, connection_type="s3", format="csv", connection_options={"paths": ["s3://acslook-bucket/origem/customers.csv"], "recurse": True}, transformation_ctx="AmazonS3_node1710895724662")

# Script generated for node Drop Fields
DropFields_node1710895796539 = DropFields.apply(frame=AmazonS3_node1710895724662, paths=["Website", "Subscription Date", "Phone 2", "Email", "Phone 1"], transformation_ctx="DropFields_node1710895796539")

# Script generated for node Amazon S3
AmazonS3_node1710895873789 = glueContext.write_dynamic_frame.from_options(frame=DropFields_node1710895796539, connection_type="s3", format="csv", connection_options={"path": "s3://acslook-bucket/destino/", "partitionKeys": []}, transformation_ctx="AmazonS3_node1710895873789")

job.commit()