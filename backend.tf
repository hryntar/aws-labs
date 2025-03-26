terraform {
  backend "s3" {
    bucket         = "807385936603-terraform-tfstate"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-tfstate-lock"
    encrypt        = true
  }
}