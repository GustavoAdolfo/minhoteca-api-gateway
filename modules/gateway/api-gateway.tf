

resource "aws_api_gateway_account" "api_account" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_api_gateway_rest_api" "api_minhoteca" {
  name                     = var.api_name
  description              = "API do Minhoteca"
  api_key_source           = "HEADER"
  minimum_compression_size = var.api_minimum_compression_size
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(var.application_tags, { Contexto = "API" })
}

resource "aws_api_gateway_client_certificate" "default_certificate" {
  description = "Minhoteca Default Client Certificate"
  tags        = merge(var.application_tags, { Contexto = "API" })
}

