#### OPTIONS E CORS
resource "aws_api_gateway_method" "options_admin_livros" {
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.admin_livros_resource.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "options_admin_livros_integration" {
  rest_api_id          = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id          = aws_api_gateway_resource.admin_livros_resource.id
  http_method          = aws_api_gateway_method.options_admin_livros.http_method
  type                 = "MOCK"
  content_handling     = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
  timeout_milliseconds = 29000
  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "options_admin_livros_response" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_livros_resource.id
  http_method = aws_api_gateway_method.options_admin_livros.http_method
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

resource "aws_api_gateway_integration_response" "options_admin_livros_integration_response" {
  depends_on = [
    aws_api_gateway_integration.options_admin_livros_integration,
    aws_api_gateway_method_response.options_admin_livros_response
  ]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_livros_resource.id
  http_method = aws_api_gateway_method.options_admin_livros.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,x-api-access,X-API-ACCESS,X-Api-Access,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}

##### GET
resource "aws_api_gateway_method" "get_admin_livros_method" {
  #checkov:skip=CKV2_AWS_53: "Nenhum validador de requisição aplicável par ao momento"
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.admin_livros_resource.id
  http_method      = "GET"
  api_key_required = true
  authorization    = "COGNITO_USER_POOLS"

  request_parameters = {
    "method.request.querystring.page"         = false
    "method.request.querystring.sort[sortBy]" = false
    "method.request.querystring.limit"        = false
  }
}

output "get_admin_livros_method_path" {
  value = "${aws_api_gateway_resource.admin_livros_resource.path}/${aws_api_gateway_method.get_admin_livros_method.http_method}"
}

resource "aws_api_gateway_integration" "get_admin_livros_integration" {
  depends_on              = [aws_api_gateway_method.get_admin_livros_method]
  rest_api_id             = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id             = aws_api_gateway_resource.admin_livros_resource.id
  http_method             = aws_api_gateway_method.get_admin_livros_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_admin_invoke_arn
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_parameters = {
    "integration.request.querystring.page"         = "method.request.querystring.page"
    "integration.request.querystring.sort[sortBy]" = "method.request.querystring.sort[sortBy]"
    "integration.request.querystring.limit"        = "method.request.querystring.limit"
  }
}

resource "aws_api_gateway_method_response" "get_admin_livros_response_200" {
  depends_on  = [aws_api_gateway_method.get_admin_livros_method]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_livros_resource.id
  http_method = aws_api_gateway_method.get_admin_livros_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "get_admin_livros_integration_response_200" {
  depends_on  = [aws_api_gateway_integration.get_admin_livros_integration]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_livros_resource.id
  http_method = aws_api_gateway_method.get_admin_livros_method.http_method
  status_code = aws_api_gateway_method_response.get_admin_livros_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,x-api-access,X-API-ACCESS,X-Api-Access,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}

