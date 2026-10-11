locals {
  admin_usuarios_listas_routes = {
    usuarios_get = {
      resource_id        = aws_api_gateway_resource.admin_usuarios_resource.id
      http_method        = "GET"
      request_parameters = {}
    }
    usuario_get = {
      resource_id = aws_api_gateway_resource.admin_usuario_id_resource.id
      http_method = "GET"
      request_parameters = {
        "method.request.path.id" = true
      }
    }
    lista_get = {
      resource_id = aws_api_gateway_resource.admin_lista_tipo_resource.id
      http_method = "GET"
      request_parameters = {
        "method.request.path.tipo" = true
      }
    }
    lista_post = {
      resource_id        = aws_api_gateway_resource.admin_lista_resource.id
      http_method        = "POST"
      request_parameters = {}
    }
    lista_put = {
      resource_id = aws_api_gateway_resource.admin_lista_usuario_resource.id
      http_method = "PUT"
      request_parameters = {
        "method.request.path.tipo"      = true
        "method.request.path.idUsuario" = true
      }
    }
  }

  admin_usuarios_listas_cors = {
    usuarios = { resource_id = aws_api_gateway_resource.admin_usuarios_resource.id, methods = "GET,OPTIONS" }
    usuario  = { resource_id = aws_api_gateway_resource.admin_usuario_id_resource.id, methods = "GET,OPTIONS" }
    lista    = { resource_id = aws_api_gateway_resource.admin_lista_resource.id, methods = "POST,OPTIONS" }
    tipo     = { resource_id = aws_api_gateway_resource.admin_lista_tipo_resource.id, methods = "GET,OPTIONS" }
    item     = { resource_id = aws_api_gateway_resource.admin_lista_usuario_resource.id, methods = "PUT,OPTIONS" }
  }
}

resource "aws_api_gateway_method" "admin_usuarios_listas" {
  for_each = local.admin_usuarios_listas_routes

  rest_api_id        = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id        = each.value.resource_id
  http_method        = each.value.http_method
  authorization      = "COGNITO_USER_POOLS"
  authorizer_id      = aws_api_gateway_authorizer.authorizer.id
  api_key_required   = true
  request_parameters = each.value.request_parameters
}

resource "aws_api_gateway_integration" "admin_usuarios_listas" {
  for_each = local.admin_usuarios_listas_routes

  rest_api_id             = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id             = each.value.resource_id
  http_method             = aws_api_gateway_method.admin_usuarios_listas[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_admin_invoke_arn
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_method" "options_admin_usuarios_listas" {
  for_each = local.admin_usuarios_listas_cors

  rest_api_id      = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id      = each.value.resource_id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "options_admin_usuarios_listas" {
  for_each = local.admin_usuarios_listas_cors

  rest_api_id          = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id          = each.value.resource_id
  http_method          = aws_api_gateway_method.options_admin_usuarios_listas[each.key].http_method
  type                 = "MOCK"
  content_handling     = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "options_admin_usuarios_listas" {
  for_each = local.admin_usuarios_listas_cors

  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = each.value.resource_id
  http_method = aws_api_gateway_method.options_admin_usuarios_listas[each.key].http_method
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

resource "aws_api_gateway_integration_response" "options_admin_usuarios_listas" {
  for_each = local.admin_usuarios_listas_cors

  depends_on = [aws_api_gateway_integration.options_admin_usuarios_listas]

  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  resource_id = each.value.resource_id
  http_method = aws_api_gateway_method.options_admin_usuarios_listas[each.key].http_method
  status_code = aws_api_gateway_method_response.options_admin_usuarios_listas[each.key].status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = "'${var.api_cors_allowed_origin}'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,Authorization,x-api-access,X-API-ACCESS,X-Api-Access,X-Api-Key,X-Amz-Date,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods"     = "'${each.value.methods}'"
    "method.response.header.Access-Control-Max-Age"           = "'7200'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }
}
