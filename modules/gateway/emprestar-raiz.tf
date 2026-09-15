resource "aws_api_gateway_resource" "emprestar" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.resource_v1.id
  path_part   = "emprestimo"
}

### OPTIONS E CORS

resource "aws_api_gateway_method" "emprestar_method_options" {
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.emprestar.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "emprestar_options_integration" {
  rest_api_id          = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id          = aws_api_gateway_resource.emprestar.id
  http_method          = aws_api_gateway_method.emprestar_method_options.http_method
  type                 = "MOCK"
  content_handling     = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "emprestar_options_response" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.emprestar.id
  http_method = aws_api_gateway_method.emprestar_method_options.http_method
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

resource "aws_api_gateway_integration_response" "emprestar_options_integration_response" {
  depends_on = [
    aws_api_gateway_integration.emprestar_options_integration,
    aws_api_gateway_method_response.emprestar_options_response
  ]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.emprestar.id
  http_method = aws_api_gateway_method.emprestar_method_options.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key,x-api-access,X-API-ACCESS,X-Api-Access'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}
