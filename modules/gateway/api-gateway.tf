resource "aws_api_gateway_account" "api_account" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_api_gateway_rest_api" "api_minhoteca" {
  name                     = var.api_name
  description              = "API do Minhoteca"
  api_key_source           = "HEADER"
  minimum_compression_size = var.api_minimum_compression
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(var.application_tags, { Contexto = "API" })
}

resource "aws_api_gateway_client_certificate" "default_certificate" {
  description = "Minhoteca Default Client Certificate"
  tags        = merge(var.application_tags, { Contexto = "API" })
}

resource "aws_api_gateway_api_key" "api_key" {
  name        = var.api_key_name
  description = "Minhoteca API key"
  enabled     = true
  tags        = merge(var.application_tags, { Contexto = "API" })
}

resource "aws_api_gateway_authorizer" "authorizer" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.api_minhoteca.id
  provider_arns = [var.cognito_user_pool_arn]
}
