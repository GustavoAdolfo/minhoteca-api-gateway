resource "aws_api_gateway_resource" "getAutor_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.resource_v1.id
  path_part   = "autor"
}

resource "aws_api_gateway_resource" "gateway_getAutor" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.getAutor_resource.id
  path_part   = "{id}"
}

#### OPTIONS E CORS
resource "aws_api_gateway_method" "optionsAutor_method" {
  #checkov:skip=CKV2_AWS_53: "Nenhum validador de requisição aplicável par ao momento"
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.gateway_getAutor.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "optionsAutor_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.gateway_getAutor.id
  # http_method = "OPTIONS"
  http_method          = aws_api_gateway_method.optionsAutor_method.http_method
  type                 = "MOCK"
  content_handling     = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
  timeout_milliseconds = 29000
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "optionsAutor_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.gateway_getAutor.id
  http_method = aws_api_gateway_method.optionsAutor_method.http_method
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

resource "aws_api_gateway_integration_response" "optionsAutor_integration_response" {
  depends_on = [
    aws_api_gateway_integration.optionsAutor_integration,
    aws_api_gateway_method_response.optionsAutor_method_response
  ]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.gateway_getAutor.id
  http_method = aws_api_gateway_method.optionsAutor_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,Authorization,x-api-access,X-API-ACCESS,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,PUT'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}

##### GET

resource "aws_api_gateway_method" "getAutor_method" {
  #checkov:skip=CKV2_AWS_53: "Nenhum validador de requisição aplicável par ao momento"
  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = aws_api_gateway_resource.gateway_getAutor.id
  http_method      = "GET"
  api_key_required = true
  authorization    = "NONE"
}

output "getAutor_method_path" {
  value = "${aws_api_gateway_resource.gateway_getAutor.path}/${aws_api_gateway_method.getAutor_method.http_method}"
}

resource "aws_api_gateway_integration" "getAutor_integration" {
  depends_on = [
    aws_api_gateway_method.getAutor_method
  ]
  rest_api_id             = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id             = aws_api_gateway_resource.gateway_getAutor.id
  http_method             = aws_api_gateway_method.getAutor_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_acervo_invoke_arn
}

resource "aws_api_gateway_model" "getAutor_response_model" {
  rest_api_id  = aws_api_gateway_rest_api.api_minhoteca.id
  name         = "getAutorResponseModel"
  description  = "API response for getAutor method"
  content_type = "application/json"
  schema = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#"
    title     = "getAutorResponse"
    type      = "object"
    required  = ["id", "nome", "idPais", "pais", "totalLivros"]
    properties = {
      totalLivros        = { type = "number" },
      revisar            = { type = "boolean" },
      id                 = { type = "string" },
      nome               = { type = "string" },
      imagemPadrao       = { type = "string" },
      imagemDispositivos = { type = "string" },
      urlReferencia      = { type = "string" },
      idPais             = { type = "string" },
      pais = { type = "object",
        properties = {
          isoAlpha3  = { type = "string" },
          nome       = { type = "string" },
          bandeira   = { type = "string" },
          isoNumeric = { type = "number" }
        }
      },
      livros = {
        type = "array",
        items = {
          type     = "object",
          required = ["id", "titulo"],
          properties = {
            id        = { type = "string" },
            titulo    = { type = "string" },
            subtitulo = { type = "string" },
          }
        }
      }
    }
  })
}

resource "aws_api_gateway_method_response" "getAutor_response_200" {
  depends_on  = [aws_api_gateway_method.getAutor_method]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.gateway_getAutor.id
  http_method = aws_api_gateway_method.getAutor_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = aws_api_gateway_model.getAutor_response_model.name
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "getAutor_integration_response_200" {
  depends_on = [
    aws_api_gateway_integration.getAutor_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = aws_api_gateway_resource.gateway_getAutor.id
  http_method = aws_api_gateway_method.getAutor_method.http_method
  status_code = aws_api_gateway_method_response.getAutor_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,Authorization,x-api-access,X-API-ACCESS,X-Amz-Date,X-Amz-Security-Token,X-Api-Key'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}
