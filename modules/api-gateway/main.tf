resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = "API for Courses and Authors"
}

resource "aws_api_gateway_resource" "authors" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "authors"
}

resource "aws_api_gateway_resource" "courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "courses"
}

resource "aws_api_gateway_resource" "courses_id" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.courses.id
  path_part   = "{id}"
}

locals {
  lambda_uri_map = {
    for key, arn in var.lambda_integration_uri_map :
    key => "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${arn}/invocations"
  }

   cors_headers = {
    "Access-Control-Allow-Origin"  = "'*'"
    "Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'"
  }
}

# GET /authors
resource "aws_api_gateway_method" "get_authors" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_authors" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.get_authors.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = local.lambda_uri_map["get_authors"]
  depends_on              = [aws_api_gateway_method.get_authors]
}

# GET /courses
resource "aws_api_gateway_method" "get_courses" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_courses" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.get_courses.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = local.lambda_uri_map["get_courses"]
  depends_on              = [aws_api_gateway_method.get_courses]
}

# POST /courses
resource "aws_api_gateway_method" "save_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "save_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.save_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = local.lambda_uri_map["save_course"]
  depends_on              = [aws_api_gateway_method.save_course]
}

# GET /courses/{id}
resource "aws_api_gateway_method" "get_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses_id.id
  http_method             = aws_api_gateway_method.get_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = local.lambda_uri_map["get_course"]
  depends_on              = [aws_api_gateway_method.get_course]
}

# PUT /courses/{id}
resource "aws_api_gateway_method" "update_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "update_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses_id.id
  http_method             = aws_api_gateway_method.update_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = local.lambda_uri_map["update_course"]
  depends_on              = [aws_api_gateway_method.update_course]
}

# DELETE /courses/{id}
resource "aws_api_gateway_method" "delete_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "delete_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses_id.id
  http_method             = aws_api_gateway_method.delete_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = local.lambda_uri_map["delete_course"]
  depends_on              = [aws_api_gateway_method.delete_course]
}

resource "aws_api_gateway_method" "cors_authors" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_authors" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = "OPTIONS"
  type                    = "MOCK"
  request_templates       = { "application/json" = "{\"statusCode\": 200}" }

  depends_on = [aws_api_gateway_method.cors_authors]
}

resource "aws_api_gateway_integration_response" "cors_authors" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    for key, value in local.cors_headers :
    "method.response.header.${key}" => value
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_integration.cors_authors]
}

resource "aws_api_gateway_method_response" "cors_authors" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = "OPTIONS"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    for key in keys(local.cors_headers) : "method.response.header.${key}" => true
  }

  depends_on = [aws_api_gateway_method.cors_authors]
}

resource "aws_api_gateway_method" "cors_courses" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_courses" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = "OPTIONS"
  type                    = "MOCK"
  request_templates       = {
    "application/json" = "{\"statusCode\": 200}"
  }

  depends_on = [aws_api_gateway_method.cors_courses]
}

resource "aws_api_gateway_integration_response" "cors_courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    for key, value in local.cors_headers :
    "method.response.header.${key}" => value
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_integration.cors_courses]
}

resource "aws_api_gateway_method_response" "cors_courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    for key in keys(local.cors_headers) :
    "method.response.header.${key}" => true
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [aws_api_gateway_method.cors_courses]
}

resource "aws_api_gateway_method" "cors_courses_id" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_courses_id" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses_id.id
  http_method             = "OPTIONS"
  type                    = "MOCK"
  request_templates       = {
    "application/json" = "{\"statusCode\": 200}"
  }

  depends_on = [aws_api_gateway_method.cors_courses_id]
}

resource "aws_api_gateway_integration_response" "cors_courses_id" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    for key, value in local.cors_headers :
    "method.response.header.${key}" => value
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_integration.cors_courses_id]
}

resource "aws_api_gateway_method_response" "cors_courses_id" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    for key in keys(local.cors_headers) :
    "method.response.header.${key}" => true
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [aws_api_gateway_method.cors_courses_id]
}

# deployment
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.get_authors,
    aws_api_gateway_integration.get_courses,
    aws_api_gateway_integration.save_course,
    aws_api_gateway_integration.get_course,
    aws_api_gateway_integration.update_course,
    aws_api_gateway_integration.delete_course,
    aws_api_gateway_integration.cors_authors,
    aws_api_gateway_integration.cors_courses,
    aws_api_gateway_integration.cors_courses_id
  ]
}

resource "aws_api_gateway_stage" "this" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
}

# Lambda permissions for API Gateway
resource "aws_lambda_permission" "get_authors" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_integration_uri_map["get_authors"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/${aws_api_gateway_method.get_authors.http_method}${aws_api_gateway_resource.authors.path}"
}

resource "aws_lambda_permission" "get_courses" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_integration_uri_map["get_courses"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/${aws_api_gateway_method.get_courses.http_method}${aws_api_gateway_resource.courses.path}"
}

resource "aws_lambda_permission" "save_course" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_integration_uri_map["save_course"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/${aws_api_gateway_method.save_course.http_method}${aws_api_gateway_resource.courses.path}"
}

resource "aws_lambda_permission" "get_course" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_integration_uri_map["get_course"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/${aws_api_gateway_method.get_course.http_method}${aws_api_gateway_resource.courses_id.path}"
}

resource "aws_lambda_permission" "update_course" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_integration_uri_map["update_course"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/${aws_api_gateway_method.update_course.http_method}${aws_api_gateway_resource.courses_id.path}"
}

resource "aws_lambda_permission" "delete_course" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_integration_uri_map["delete_course"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/${aws_api_gateway_method.delete_course.http_method}${aws_api_gateway_resource.courses_id.path}"
}
