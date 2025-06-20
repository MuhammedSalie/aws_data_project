import boto3
import os
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
from io import BytesIO

s3 = boto3.client('s3')

def lambda_handler(event, context):
    bucket = os.environ['BUCKET_NAME']
    for record in event['Records']:
        key = record['s3']['object']['key']
        if not key.endswith('.csv'):
            print(f"Skipping non-csv file {key}")
            continue

        print(f"Processing file: {key}")
        # Download CSV from S3
        csv_obj = s3.get_object(Bucket=bucket, Key=key)
        df = pd.read_csv(csv_obj['Body'])

        # Convert to Parquet in-memory
        table = pa.Table.from_pandas(df)
        out_buffer = BytesIO()
        pq.write_table(table, out_buffer)

        # Upload Parquet file to processed/
        parquet_key = key.replace('raw/', 'processed/').replace('.csv', '.parquet')
        s3.put_object(Bucket=bucket, Key=parquet_key, Body=out_buffer.getvalue())
        print(f"Uploaded parquet file to: {parquet_key}")

    return {
        'statusCode': 200,
        'body': 'CSV files converted to Parquet successfully'
    }
