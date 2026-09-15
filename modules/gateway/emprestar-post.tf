#### POST

resource "aws_api_gateway_method" "post_emprestar" {
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.emprestar.id
  http_method      = "POST"
  api_key_required = true
  # authorization    = "NONE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.authorizer.id
}

resource "aws_api_gateway_integration" "post_emprestar_integration" {
  depends_on = [
    aws_api_gateway_method.post_emprestar,
  ]
  rest_api_id             = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id             = aws_api_gateway_resource.emprestar.id
  http_method             = aws_api_gateway_method.post_emprestar.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_usuario_invoke_arn
}

resource "aws_api_gateway_method_response" "post_emprestar_response_200" {
  depends_on  = [aws_api_gateway_method.post_emprestar]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.emprestar.id
  http_method = aws_api_gateway_method.post_emprestar.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "post_emprestar_integration_response_200" {
  depends_on = [
    aws_api_gateway_integration.post_emprestar_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.emprestar.id
  http_method = aws_api_gateway_method.post_emprestar.http_method
  status_code = aws_api_gateway_method_response.post_emprestar_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key,x-api-access,X-API-ACCESS,X-Api-Access'"
    "method.response.header.Access-Control-Allow-Methods"     = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}
