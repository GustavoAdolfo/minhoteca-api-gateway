mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"logs:PutLogEvents\",\"Resource\":\"*\"}]}"
    }
  }
}
mock_provider "random" {}

override_data {
  target = data.aws_region.use_terms
  values = { name = "us-east-1" }
}

override_data {
  target = data.aws_caller_identity.use_terms
  values = { account_id = "123456789012" }
}

override_data {
  target = data.aws_kms_alias.use_terms
  values = { target_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012" }
}

variables {
  application_tags             = {}
  api_minimum_compression_size = "0"
  api_name                     = "minhoteca-test"
  api_key_name                 = "minhoteca-test"
  cognito_user_pool_arn        = "arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_test"
  lambda_acervo_arn            = "arn:aws:lambda:us-east-1:123456789012:function:minhoteca-acervo"
  lambda_acervo_invoke_arn     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:minhoteca-acervo/invocations"
  lambda_usuario_arn           = "arn:aws:lambda:us-east-1:123456789012:function:minhoteca-usuario"
  lambda_usuario_invoke_arn    = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:minhoteca-usuario/invocations"
  lambda_admin_arn             = "arn:aws:lambda:us-east-1:123456789012:function:minhoteca-administracao"
  lambda_admin_invoke_arn      = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:minhoteca-administracao/invocations"
  cache_cluster_enabled        = false
  cache_cluster_size           = 0.5
  api_stage_default_variables  = {}
  enable_api_xray              = false
  api_log_retention_in_days    = 7
  api_quota_settings_limit     = "1000"
  api_quota_settings_offset    = "0"
  api_quota_settings_period    = "DAY"
  api_throttle_settings_burst  = "100"
  api_throttle_settings_rate   = "50"
  metrics_enabled              = false
}

run "admin_usuarios_listas" {
  command = plan

  assert {
    condition = (
      length(aws_api_gateway_method.admin_usuarios_listas) == 5 &&
      aws_api_gateway_method.admin_usuarios_listas["usuarios_get"].http_method == "GET" &&
      aws_api_gateway_method.admin_usuarios_listas["usuario_get"].http_method == "GET" &&
      aws_api_gateway_method.admin_usuarios_listas["lista_get"].http_method == "GET" &&
      aws_api_gateway_method.admin_usuarios_listas["lista_post"].http_method == "POST" &&
      aws_api_gateway_method.admin_usuarios_listas["lista_put"].http_method == "PUT"
    )
    error_message = "Devem existir exatamente três GET, um POST e um PUT nas rotas solicitadas."
  }

  assert {
    condition = (
      aws_api_gateway_resource.use_terms.path_part == "termos-de-uso" &&
      aws_api_gateway_method.use_terms_get.http_method == "GET" &&
      aws_api_gateway_method.use_terms_get.authorization == "NONE" &&
      aws_api_gateway_method.use_terms_get.api_key_required
    )
    error_message = "Termos devem usar GET /v1/termos-de-uso sem authorizer, com API key."
  }

  assert {
    condition = (
      aws_api_gateway_integration.use_terms_get_integration.type == "AWS" &&
      aws_api_gateway_integration.use_terms_get_integration.integration_http_method == "GET" &&
      aws_api_gateway_integration.use_terms_get_integration.uri == "arn:aws:apigateway:us-east-1:s3:path/minhoteca-contratos/termos-de-uso.md" &&
      length(coalesce(aws_api_gateway_integration_response.use_terms_get_integration_response_200.response_templates, {})) == 0 &&
      aws_api_gateway_integration_response.use_terms_get_integration_response_200.selection_pattern == "200" &&
      aws_api_gateway_integration_response.use_terms_get_integration_response_200.response_parameters["method.response.header.Content-Type"] == "'text/markdown; charset=utf-8'"
    )
    error_message = "A integracao deve retornar o Markdown do objeto correto sem transformar seu corpo."
  }

  assert {
    condition = (
      jsondecode(aws_iam_role.use_terms_s3.assume_role_policy).Statement[0].Principal.Service == "apigateway.amazonaws.com" &&
      jsondecode(aws_iam_role_policy.use_terms_s3.policy).Statement[0].Resource == "arn:aws:s3:::minhoteca-contratos/termos-de-uso.md" &&
      jsondecode(aws_iam_role_policy.use_terms_s3.policy).Statement[0].Action == ["s3:GetObject"] &&
      jsondecode(aws_iam_role_policy.use_terms_s3.policy).Statement[1].Action == ["kms:Decrypt"] &&
      jsondecode(aws_iam_role_policy.use_terms_s3.policy).Statement[1].Resource == data.aws_kms_alias.use_terms.target_key_arn &&
      jsondecode(aws_iam_role_policy.use_terms_s3.policy).Statement[1].Condition.StringEquals["kms:ViaService"] == "s3.us-east-1.amazonaws.com"
    )
    error_message = "A role deve conceder somente leitura do objeto e descriptografia da chave Minhoteca via S3."
  }

  assert {
    condition = (
      aws_api_gateway_integration_response.use_terms_error["forbidden"].status_code == "403" &&
      aws_api_gateway_integration_response.use_terms_error["forbidden"].selection_pattern == "403" &&
      aws_api_gateway_integration_response.use_terms_error["not_found"].status_code == "404" &&
      aws_api_gateway_integration_response.use_terms_error["not_found"].selection_pattern == "404" &&
      aws_api_gateway_integration_response.use_terms_error["upstream"].status_code == "502" &&
      aws_api_gateway_integration_response.use_terms_error["upstream"].selection_pattern == "" &&
      aws_api_gateway_method.use_terms_options.authorization == "NONE" &&
      !aws_api_gateway_method.use_terms_options.api_key_required
    )
    error_message = "Erros S3 nao podem retornar 200; o preflight deve dispensar autenticacao."
  }
  assert {
    condition = alltrue([
      for method in aws_api_gateway_method.admin_usuarios_listas :
      method.authorization == "COGNITO_USER_POOLS" && method.api_key_required
    ])
    error_message = "As rotas administrativas devem exigir Cognito e API key."
  }

  assert {
    condition = alltrue([
      for integration in aws_api_gateway_integration.admin_usuarios_listas :
      integration.type == "AWS_PROXY" &&
      integration.integration_http_method == "POST" &&
      integration.uri == var.lambda_admin_invoke_arn
    ])
    error_message = "Todas as rotas devem usar integração proxy com a Lambda administrativa."
  }

  assert {
    condition = (
      aws_api_gateway_resource.admin_usuarios_resource.path_part == "usuarios" &&
      aws_api_gateway_resource.admin_usuario_resource.path_part == "usuario" &&
      aws_api_gateway_resource.admin_usuario_id_resource.path_part == "{id}" &&
      aws_api_gateway_resource.admin_lista_resource.path_part == "lista" &&
      aws_api_gateway_resource.admin_lista_tipo_resource.path_part == "{tipo}" &&
      aws_api_gateway_resource.admin_lista_usuario_resource.path_part == "{idUsuario}" &&
      aws_api_gateway_method.admin_usuarios_listas["usuario_get"].request_parameters["method.request.path.id"] &&
      aws_api_gateway_method.admin_usuarios_listas["lista_get"].request_parameters["method.request.path.tipo"] &&
      aws_api_gateway_method.admin_usuarios_listas["lista_put"].request_parameters["method.request.path.tipo"] &&
      aws_api_gateway_method.admin_usuarios_listas["lista_put"].request_parameters["method.request.path.idUsuario"]
    )
    error_message = "Os recursos e parâmetros devem preservar id, tipo e idUsuario."
  }

  assert {
    condition = (
      length(aws_api_gateway_method.options_admin_usuarios_listas) == 5 &&
      alltrue([
        for method in aws_api_gateway_method.options_admin_usuarios_listas :
        method.http_method == "OPTIONS" && method.authorization == "NONE" && !method.api_key_required
      ])
    )
    error_message = "Cada novo endpoint deve oferecer preflight público."
  }
}
