#### PUT

resource "aws_api_gateway_model" "perfilUsuario_put_request_model" {
  rest_api_id  = aws_api_gateway_rest_api.api_minhoteca.id
  name         = "PerfilUsuarioPutRequest"
  description  = "Payload de atualização do perfil do usuário"
  content_type = "application/json"

  schema = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#"
    title     = "PerfilUsuarioPutRequest"
    type      = "object"
    required  = ["userId"]
    properties = {
      userId = {
        type    = "string"
        pattern = "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
      }
      name = {
        type      = "string"
        minLength = 5
      }
      email = {
        type    = "string"
        pattern = "^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"
      }
    }
    additionalProperties = true
  })
}

resource "aws_api_gateway_request_validator" "perfilUsuario_put_request_validator" {
  rest_api_id                 = aws_api_gateway_rest_api.api_minhoteca.id
  name                        = "perfil-usuario-put-request-validator"
  validate_request_body       = true
  validate_request_parameters = false
}

resource "aws_api_gateway_method" "put_perfilUsuario" {
  rest_api_id          = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id          = aws_api_gateway_resource.perfilUsuario.id
  http_method          = "PUT"
  api_key_required     = true
  request_validator_id = aws_api_gateway_request_validator.perfilUsuario_put_request_validator.id
  # authorization    = "NONE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.authorizer.id

  request_models = {
    "application/json" = aws_api_gateway_model.perfilUsuario_put_request_model.name
  }
}

resource "aws_api_gateway_integration" "put_perfilUsuario_integration" {
  depends_on = [
    aws_api_gateway_method.put_perfilUsuario,
  ]
  rest_api_id             = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id             = aws_api_gateway_resource.perfilUsuario.id
  http_method             = aws_api_gateway_method.put_perfilUsuario.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_usuario_invoke_arn
}

resource "aws_api_gateway_method_response" "put_perfilUsuario_response_200" {
  depends_on  = [aws_api_gateway_method.put_perfilUsuario]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.perfilUsuario.id
  http_method = aws_api_gateway_method.put_perfilUsuario.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "put_perfilUsuario_integration_response_200" {
  depends_on = [
    aws_api_gateway_integration.put_perfilUsuario_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.perfilUsuario.id
  http_method = aws_api_gateway_method.put_perfilUsuario.http_method
  status_code = aws_api_gateway_method_response.put_perfilUsuario_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Options,Content-Type,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key,X-API-ACCESS'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,PUT,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}
