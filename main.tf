module "authors" {
  source       = "./modules/dynamodb-table"
  table_name   = "authors"
  billing_mode = "PAY_PER_REQUEST"
  attributes   = [{ name = "id", type = "S" }]
}

module "courses" {
  source       = "./modules/dynamodb-table"
  table_name   = "courses"
  billing_mode = "PAY_PER_REQUEST"
  attributes   = [{ name = "id", type = "S" }]
}

module "frontend_s3" {
  source       = "./modules/s3-hosting"
  bucket_name  = "frontend-hosting-${random_id.suffix.hex}"
  index_document = "index.html"
  error_document = "index.html"
}

module "frontend_cdn" {
  source              = "./modules/cloudfront"
  s3_website_endpoint = module.frontend_s3.website_endpoint
}

module "monitoring" {
  source = "./modules/monitoring"
}

resource "random_id" "suffix" {
  byte_length = 4
}