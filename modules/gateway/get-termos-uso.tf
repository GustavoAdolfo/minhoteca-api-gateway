resource "aws_api_gateway_resource" "use_terms" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.resource_v1.id
  path_part   = "termos-de-uso"
}

# OPTIONS (CORS)
resource "aws_api_gateway_method" "use_terms_options" {
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.use_terms.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "use_terms_options_integration" {
  rest_api_id          = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id          = aws_api_gateway_resource.use_terms.id
  http_method          = aws_api_gateway_method.use_terms_options.http_method
  type                 = "MOCK"
  content_handling     = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "use_terms_options_response" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.use_terms.id
  http_method = aws_api_gateway_method.use_terms_options.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "use_terms_options_integration_response" {
  depends_on = [
    aws_api_gateway_integration.use_terms_options_integration,
    aws_api_gateway_method_response.use_terms_options_response
  ]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.use_terms.id
  http_method = aws_api_gateway_method.use_terms_options.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'${var.api_cors_allowed_origin}'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Options,Content-Type,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}

# GET
resource "aws_api_gateway_method" "use_terms_get" {
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.use_terms.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "use_terms_get_integration" {
  depends_on = [
    aws_api_gateway_method.use_terms_get,
    aws_iam_role_policy.use_terms_s3,
  ]
  rest_api_id             = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id             = aws_api_gateway_resource.use_terms.id
  http_method             = aws_api_gateway_method.use_terms_get.http_method
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${data.aws_region.use_terms.name}:s3:path/minhoteca-contratos/termos-de-uso.md"
  credentials             = aws_iam_role.use_terms_s3.arn
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_method_response" "use_terms_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.use_terms.id
  http_method = aws_api_gateway_method.use_terms_get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Content-Type"                     = true
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "use_terms_get_integration_response_200" {
  depends_on = [
    aws_api_gateway_integration.use_terms_get_integration,
    aws_api_gateway_method_response.use_terms_get_response_200
  ]
  rest_api_id       = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id       = aws_api_gateway_resource.use_terms.id
  http_method       = aws_api_gateway_method.use_terms_get.http_method
  status_code       = aws_api_gateway_method_response.use_terms_get_response_200.status_code
  selection_pattern = "200"
  response_parameters = {
    "method.response.header.Content-Type"                     = "'text/markdown; charset=utf-8'"
    "method.response.header.Access-Control-Allow-Origin"      = "'${var.api_cors_allowed_origin}'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Options,Content-Type,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}

data "aws_region" "use_terms" {}
data "aws_caller_identity" "use_terms" {}

data "aws_kms_alias" "use_terms" {
  name = var.kms_minhoteca_alias_name
}

resource "aws_iam_role" "use_terms_s3" {
  name = "minhoteca-api-gateway-termos-s3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "apigateway.amazonaws.com" }
    }]
  })
  tags = merge(var.application_tags, { Contexto = "API" })
}

resource "aws_iam_role_policy" "use_terms_s3" {
  name = "minhoteca-api-gateway-termos-s3"
  role = aws_iam_role.use_terms_s3.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "arn:aws:s3:::minhoteca-contratos/termos-de-uso.md"
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = data.aws_kms_alias.use_terms.target_key_arn
        Condition = {
          StringEquals = {
            "kms:ViaService"    = "s3.${data.aws_region.use_terms.name}.amazonaws.com"
            "kms:CallerAccount" = data.aws_caller_identity.use_terms.account_id
          }
          StringLike = {
            "kms:EncryptionContext:aws:s3:arn" = [
              "arn:aws:s3:::minhoteca-contratos",
              "arn:aws:s3:::minhoteca-contratos/termos-de-uso.md"
            ]
          }
        }
      }
    ]
  })
}

locals {
  use_terms_errors = {
    forbidden = { status = "403", pattern = "403", message = "Acesso ao documento negado." }
    not_found = { status = "404", pattern = "404", message = "Documento nao encontrado." }
    upstream  = { status = "502", pattern = "", message = "Falha ao obter o documento." }
  }
}

resource "aws_api_gateway_method_response" "use_terms_error" {
  for_each = local.use_terms_errors

  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.use_terms.id
  http_method = aws_api_gateway_method.use_terms_get.http_method
  status_code = each.value.status
  response_parameters = {
    "method.response.header.Content-Type"                = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "use_terms_error" {
  for_each = local.use_terms_errors

  depends_on = [aws_api_gateway_integration.use_terms_get_integration]

  rest_api_id       = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id       = aws_api_gateway_resource.use_terms.id
  http_method       = aws_api_gateway_method.use_terms_get.http_method
  status_code       = aws_api_gateway_method_response.use_terms_error[each.key].status_code
  selection_pattern = each.value.pattern
  response_parameters = {
    "method.response.header.Content-Type"                = "'application/json'"
    "method.response.header.Access-Control-Allow-Origin" = "'${var.api_cors_allowed_origin}'"
  }
  response_templates = {
    "application/json" = jsonencode({ message = each.value.message })
  }
}
