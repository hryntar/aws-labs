output "api_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "api_url" {
  value = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${var.region}.amazonaws.com/${var.stage_name}"
}