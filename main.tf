provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "data_bucket" {
  bucket        = "${local.prefix}-data-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.data_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "raw_folder" {
  bucket  = aws_s3_bucket.data_bucket.bucket
  key     = "raw/"
  content = ""
}

resource "aws_s3_object" "processed_folder" {
  bucket  = aws_s3_bucket.data_bucket.bucket
  key     = "processed/"
  content = ""
}

data "aws_lambda_layer_version" "awswrangler_layer" {
  layer_name = "arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python39"
  version    = 29
}

resource "aws_lambda_function" "csv_to_parquet" {
  function_name = "csv_to_parquet_converter"
  role          = aws_iam_role.lambda_role.arn
  handler       = "csv_to_parquet.lambda_handler"
  runtime       = "python3.9"
  timeout       = 120

  filename         = "${path.module}/lambda/csv_to_parquet.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/csv_to_parquet.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.bucket
    }
  }
  layers = [
    data.aws_lambda_layer_version.awswrangler_layer.arn
  ]
}

resource "aws_lambda_permission" "allow_s3_csv_trigger" {
  statement_id  = "AllowS3InvokeCSVToParquet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_to_parquet.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_bucket.arn
}

resource "aws_s3_bucket_notification" "s3_trigger_csv_to_parquet" {
  bucket = aws_s3_bucket.data_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.csv_to_parquet.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "raw/"
    filter_suffix       = ".csv"
  }

  depends_on = [
    aws_lambda_permission.allow_s3_csv_trigger
  ]
}