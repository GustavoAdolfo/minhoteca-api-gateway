resource "aws_api_gateway_api_key" "api_key" {
  name        = var.api_key_name
  description = "Minhoteca API key"
  enabled     = true
  tags        = merge(var.application_tags, { Contexto = "API" })
}
