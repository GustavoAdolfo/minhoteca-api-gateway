output "api_id" {
  value = aws_api_gateway_rest_api.api_minhoteca.id
}
output "api_base_path" {
  value = aws_api_gateway_resource.resource_v1.path
}
output "api_key_value" {
  value     = aws_api_gateway_api_key.api_key.value
  sensitive = true
}

output "default_certificate_id" {
  value = aws_api_gateway_client_certificate.default_certificate.id
}

output "api_key_id" {
  value = aws_api_gateway_api_key.api_key.id
}

output "authorizer_id" {
  value = aws_api_gateway_authorizer.authorizer.id
}
