variable "api_name" {
  type        = string
  description = "Name of REST API"
}

variable "stage_name" {
  type        = string
  description = "Name of stage (e.g. dev)"
  default     = "dev"
}

variable "lambda_integration_uri_map" {
  description = "Map of method identifiers to Lambda integration URIs"
  type        = map(string)
}

variable "region" {
  type    = string
  default = "eu-central-1"
}