#### OPTIONS E CORS (/v1/admin/livro)
resource "aws_api_gateway_method" "options_admin_livro_post" {
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.admin_livro_resource.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "options_admin_livro_post_integration" {
  rest_api_id          = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id          = aws_api_gateway_resource.admin_livro_resource.id
  http_method          = aws_api_gateway_method.options_admin_livro_post.http_method
  type                 = "MOCK"
  content_handling     = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
  timeout_milliseconds = 29000
  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "options_admin_livro_post_response" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_livro_resource.id
  http_method = aws_api_gateway_method.options_admin_livro_post.http_method
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

resource "aws_api_gateway_integration_response" "options_admin_livro_post_integration_response" {
  depends_on = [
    aws_api_gateway_integration.options_admin_livro_post_integration,
    aws_api_gateway_method_response.options_admin_livro_post_response
  ]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_livro_resource.id
  http_method = aws_api_gateway_method.options_admin_livro_post.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,x-api-access,X-API-ACCESS,X-Api-Access,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
    "method.response.header.Access-Control-Allow-Methods"     = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}

#### POST
resource "aws_api_gateway_model" "admin_livro_post_request_model" {
  rest_api_id  = aws_api_gateway_rest_api.api_minhoteca.id
  name         = "AdminLivroPostRequest"
  description  = "Payload de criação de livro"
  content_type = "application/json"

  schema = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#"
    title     = "AdminLivroPostRequest"
    type      = "object"
    required  = ["titulo", "isbn", "paginas", "anoPublicacao", "idioma"]
    properties = {
      id = { type = "string" }
      titulo = {
        type      = "string"
        minLength = 1
      }
      subtitulo         = { type = ["string", "null"] }
      sinopse           = { type = "string" }
      imagemCapaUrl     = { type = "string" }
      imagemCapaMiniUrl = { type = "string" }
      link              = { type = "string" }
      linkAWS           = { type = "string" }
      autorId           = { type = "string" }
      editoraId         = { type = "string" }
      isbn              = { type = ["string", "number"] }
      paginas           = { type = ["string", "number"] }
      anoPublicacao     = { type = ["string", "number"] }
      idioma = {
        type      = "string"
        minLength = 1
      }
      status     = { type = "string" }
      situacao   = { type = ["string", "number"] }
      revisar    = { type = "boolean" }
      emprestado = { type = "boolean" }
      autor      = { type = "object", additionalProperties = true }
      editora    = { type = "object", additionalProperties = true }
    }
    additionalProperties = true
  })
}

resource "aws_api_gateway_request_validator" "admin_livro_post_request_validator" {
  rest_api_id                 = aws_api_gateway_rest_api.api_minhoteca.id
  name                        = "admin-livro-post-request-validator"
  validate_request_body       = true
  validate_request_parameters = false
}

resource "aws_api_gateway_method" "post_admin_livro_method" {
  rest_api_id          = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id          = aws_api_gateway_resource.admin_livro_resource.id
  http_method          = "POST"
  api_key_required     = true
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.authorizer.id
  request_validator_id = aws_api_gateway_request_validator.admin_livro_post_request_validator.id

  request_models = {
    "application/json" = aws_api_gateway_model.admin_livro_post_request_model.name
  }
}

output "post_admin_livro_method_path" {
  value = "${aws_api_gateway_resource.admin_livro_resource.path}/${aws_api_gateway_method.post_admin_livro_method.http_method}"
}

resource "aws_api_gateway_integration" "post_admin_livro_integration" {
  depends_on              = [aws_api_gateway_method.post_admin_livro_method]
  rest_api_id             = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id             = aws_api_gateway_resource.admin_livro_resource.id
  http_method             = aws_api_gateway_method.post_admin_livro_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_admin_invoke_arn
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_method_response" "post_admin_livro_response_200" {
  depends_on  = [aws_api_gateway_method.post_admin_livro_method]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_livro_resource.id
  http_method = aws_api_gateway_method.post_admin_livro_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "post_admin_livro_integration_response_200" {
  depends_on  = [aws_api_gateway_integration.post_admin_livro_integration]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_livro_resource.id
  http_method = aws_api_gateway_method.post_admin_livro_method.http_method
  status_code = aws_api_gateway_method_response.post_admin_livro_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,x-api-access,X-API-ACCESS,X-Api-Access,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
    "method.response.header.Access-Control-Allow-Methods"     = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}
