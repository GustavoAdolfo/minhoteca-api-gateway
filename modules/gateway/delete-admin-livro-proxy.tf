#### DELETE (/v1/admin/livro/{id}) - remoção lógica
resource "aws_api_gateway_method" "delete_admin_livro_method" {
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.admin_livro_id_resource.id
  http_method      = "DELETE"
  api_key_required = true
  authorization    = "COGNITO_USER_POOLS"
  authorizer_id    = aws_api_gateway_authorizer.authorizer.id

  request_parameters = {
    "method.request.path.id" = true
  }
}

output "delete_admin_livro_method_path" {
  value = "${aws_api_gateway_resource.admin_livro_id_resource.path}/${aws_api_gateway_method.delete_admin_livro_method.http_method}"
}

resource "aws_api_gateway_integration" "delete_admin_livro_integration" {
  depends_on              = [aws_api_gateway_method.delete_admin_livro_method]
  rest_api_id             = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id             = aws_api_gateway_resource.admin_livro_id_resource.id
  http_method             = aws_api_gateway_method.delete_admin_livro_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_admin_invoke_arn
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_method_response" "delete_admin_livro_response_200" {
  depends_on  = [aws_api_gateway_method.delete_admin_livro_method]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_livro_id_resource.id
  http_method = aws_api_gateway_method.delete_admin_livro_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "delete_admin_livro_integration_response_200" {
  depends_on  = [aws_api_gateway_integration.delete_admin_livro_integration]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_livro_id_resource.id
  http_method = aws_api_gateway_method.delete_admin_livro_method.http_method
  status_code = aws_api_gateway_method_response.delete_admin_livro_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,x-api-access,X-API-ACCESS,X-Api-Access,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}
