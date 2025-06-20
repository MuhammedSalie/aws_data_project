# AWS region
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Base prefix variable
variable "prefix_base" {
  description = "Base prefix for resource names"
  type        = string
  default     = "etl-csv"
}

# Local prefix with date only (e.g., etl-csv-20250620)
locals {
  prefix = "${var.prefix_base}-${formatdate("YYYYMMDD", timestamp())}"
}

