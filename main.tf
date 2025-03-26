provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bucket-for-terraform-lab"
}