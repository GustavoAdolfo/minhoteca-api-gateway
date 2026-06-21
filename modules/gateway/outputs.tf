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

output "api_configuration_json" {
  description = "A JSON representation of all API Gateway resources to trigger a new deployment on change."

  # No Terraform não é possível referenciar recursos internos de módulos filhos.
  # Uma solução mais escalável e de fácil manutenção para o API Gateway é gerar
  # um hash baseado no conteúdo de todos os arquivos .tf de configuração da API.
  value = jsonencode([
    for f in fileset(path.module, "**/*.tf") : filesha1("${path.module}/${f}")
  ])
}
