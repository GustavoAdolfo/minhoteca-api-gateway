#### PUT (/v1/admin/editora/{id})
resource "aws_api_gateway_model" "admin_editora_put_request_model" {
  rest_api_id  = aws_api_gateway_rest_api.api_minhoteca.id
  name         = "AdminEditoraPutRequest"
  description  = "Payload de atualização de editora"
  content_type = "application/json"

  schema = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#"
    title     = "AdminEditoraPutRequest"
    type      = "object"
    required  = ["nome", "pais"]
    properties = {
      id = { type = "string" }
      nome = {
        type      = "string"
        minLength = 1
      }
      website = { type = "string" }
      pais = {
        type    = "string"
        pattern = "^[A-Za-z]{3}$"
      }
      logoUrl = { type = "string" }
      email = {
        type    = "string"
        pattern = "^$|^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"
      }
    }
    additionalProperties = true
  })
}

resource "aws_api_gateway_request_validator" "admin_editora_put_request_validator" {
  rest_api_id                 = aws_api_gateway_rest_api.api_minhoteca.id
  name                        = "admin-editora-put-request-validator"
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "put_admin_editora_method" {
  rest_api_id          = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id          = aws_api_gateway_resource.admin_editora_id_resource.id
  http_method          = "PUT"
  api_key_required     = true
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.authorizer.id
  request_validator_id = aws_api_gateway_request_validator.admin_editora_put_request_validator.id

  request_parameters = {
    "method.request.path.id" = true
  }

  request_models = {
    "application/json" = aws_api_gateway_model.admin_editora_put_request_model.name
  }
}

output "put_admin_editora_method_path" {
  value = "${aws_api_gateway_resource.admin_editora_id_resource.path}/${aws_api_gateway_method.put_admin_editora_method.http_method}"
}

resource "aws_api_gateway_integration" "put_admin_editora_integration" {
  depends_on              = [aws_api_gateway_method.put_admin_editora_method]
  rest_api_id             = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id             = aws_api_gateway_resource.admin_editora_id_resource.id
  http_method             = aws_api_gateway_method.put_admin_editora_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_admin_invoke_arn
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_method_response" "put_admin_editora_response_200" {
  depends_on  = [aws_api_gateway_method.put_admin_editora_method]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_editora_id_resource.id
  http_method = aws_api_gateway_method.put_admin_editora_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "put_admin_editora_integration_response_200" {
  depends_on  = [aws_api_gateway_integration.put_admin_editora_integration]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.admin_editora_id_resource.id
  http_method = aws_api_gateway_method.put_admin_editora_method.http_method
  status_code = aws_api_gateway_method_response.put_admin_editora_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,x-api-access,X-API-ACCESS,X-Api-Access,Authorization,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,PUT,OPTIONS'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}
