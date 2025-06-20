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

resource "aws_s3_object" "scripts_folder" {
  bucket  = aws_s3_bucket.data_bucket.bucket
  key     = "scripts/"
  content = ""
}

