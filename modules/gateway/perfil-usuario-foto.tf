resource "aws_api_gateway_resource" "perfilFoto" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.perfilUsuario.id
  path_part   = "foto"
}

#### OPTIONS E CORS
resource "aws_api_gateway_method" "perfilFoto_method_options" {
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.perfilFoto.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "perfilFoto_options_integration" {
  rest_api_id          = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id          = aws_api_gateway_resource.perfilFoto.id
  http_method          = aws_api_gateway_method.perfilFoto_method_options.http_method
  type                 = "MOCK"
  content_handling     = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "perfilFoto_options_response" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.perfilFoto.id
  http_method = aws_api_gateway_method.perfilFoto_method_options.http_method
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

resource "aws_api_gateway_integration_response" "perfilFoto_options_integration_response" {
  depends_on = [
    aws_api_gateway_integration.perfilFoto_options_integration,
    aws_api_gateway_method_response.perfilFoto_options_response
  ]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.perfilFoto.id
  http_method = aws_api_gateway_method.perfilFoto_method_options.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Options,Content-Type,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key,X-API-ACCESS'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,PUT,POST,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}

#### POST

resource "aws_api_gateway_model" "fotoPerfilUsuario_post_request_model" {
  rest_api_id  = aws_api_gateway_rest_api.api_minhoteca.id
  name         = "FotoPerfilUsuarioPostRequest"
  description  = "Payload de atualização da foto de perfil do usuário"
  content_type = "application/json"

  schema = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#"
    title     = "FotoPerfilUsuarioPostRequest"
    type      = "object"
    required  = ["contentType", "fileType", "method"]
    properties = {
      contentType = {
        type = "string"
      }
      fileType = {
        type = "string"
      }
      method = {
        type = "string"
      }
    }
    additionalProperties = true
  })
}

resource "aws_api_gateway_method" "post_perfilFoto" {
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.perfilFoto.id
  http_method      = "POST"
  api_key_required = true
  authorization    = "COGNITO_USER_POOLS"
  authorizer_id    = aws_api_gateway_authorizer.authorizer.id

  request_models = {
    "application/json" = aws_api_gateway_model.fotoPerfilUsuario_post_request_model.name
  }
}

resource "aws_api_gateway_integration" "post_perfilFoto_integration" {
  depends_on = [aws_api_gateway_method.post_perfilFoto]

  rest_api_id             = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id             = aws_api_gateway_resource.perfilFoto.id
  http_method             = aws_api_gateway_method.post_perfilFoto.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_usuario_invoke_arn
}

resource "aws_api_gateway_method_response" "post_perfilFoto_response_200" {
  depends_on  = [aws_api_gateway_method.post_perfilFoto]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.perfilFoto.id
  http_method = aws_api_gateway_method.post_perfilFoto.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "post_perfilFoto_integration_response_200" {
  depends_on = [aws_api_gateway_integration.post_perfilFoto_integration]

  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.perfilFoto.id
  http_method = aws_api_gateway_method.post_perfilFoto.http_method
  status_code = aws_api_gateway_method_response.post_perfilFoto_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Options,Content-Type,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key,X-API-ACCESS'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,PUT,POST,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }
}
