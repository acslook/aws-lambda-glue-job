provider "aws" {
  region = var.REGION
}

terraform {
  backend "s3" {
    bucket = "acslook-bucket"
    key    = "terraform/glue"
    region = "us-east-1"
  }
}