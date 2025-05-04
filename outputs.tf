output "website_endpoint" {
  value = module.frontend_s3.website_endpoint
}

output "domain_name" {
  value = module.frontend_cdn.domain_name
}