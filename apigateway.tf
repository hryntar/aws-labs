module "api_gateway" {
  source      = "./modules/api-gateway"
  api_name    = "courses-api"
  stage_name  = "dev"
  region      = var.aws_region

  lambda_integration_uri_map = {
    get_authors    = module.get_all_authors.function_arn
    get_courses    = module.get_all_courses.function_arn
    get_course     = module.get_course.function_arn
    save_course    = module.save_course.function_arn
    update_course  = module.update_course.function_arn
    delete_course  = module.delete_course.function_arn
  }
}