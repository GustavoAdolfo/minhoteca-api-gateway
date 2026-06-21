resource "aws_api_gateway_stage" "stage_default" {
  stage_name    = "DEFAULT"
  rest_api_id   = aws_api_gateway_rest_api.api_minhoteca.id
  deployment_id = aws_api_gateway_deployment.api_deploy.id

  cache_cluster_enabled = var.cache_cluster_enabled
  cache_cluster_size    = var.cache_cluster_size
  variables             = var.api_stage_default_variables
  xray_tracing_enabled  = var.enable_api_xray
  client_certificate_id = aws_api_gateway_client_certificate.default_certificate.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.log_group.arn
    format          = "$context.extendedRequestId $context.identity.sourceIp $context.identity.caller $context.identity.user [$context.requestTime] \"$context.httpMethod $context.resourcePath $context.protocol\" $context.status $context.responseLength $context.requestId"
  }

  tags       = merge(var.application_tags, { Contexto = "API" })
  depends_on = [aws_cloudwatch_log_group.log_group]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "minhoteca-api-execution-logs_${aws_api_gateway_rest_api.api_minhoteca.id}/DEFAULT"
  retention_in_days = var.api_log_retention_in_days
  # kms_key_id        = data.aws_kms_key.default_kms_alias.arn
  tags = merge(var.application_tags, { Contexto = "API" })
}

# resource "aws_iam_policy" "log_policy" {
#   name   = "minhoteca-api-default-stage-log-policy"
#   path   = "/"
#   policy = data.aws_iam_policy_document.log_policy.json
# }

# resource "aws_wafv2_web_acl_association" "waf_association" {
#   resource_arn = aws_api_gateway_stage.stage_default.arn
#   web_acl_arn  = var.plv_waf2_regional_arn
# }

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name        = "minhoteca-api-usage-plan"
  description = "minhoteca API usage plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.api_minhoteca.id
    stage  = aws_api_gateway_stage.stage_default.stage_name
  }
  quota_settings {
    limit  = var.api_quota_settings_limit
    offset = var.api_quota_settings_offset
    period = var.api_quota_settings_period
  }
  throttle_settings {
    burst_limit = var.api_throttle_settings_burst
    rate_limit  = var.api_throttle_settings_rate
  }
  tags = merge(var.application_tags, { Contexto = "API" })
}

resource "aws_api_gateway_usage_plan_key" "api_upkey" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}


#### methods setting

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  stage_name  = aws_api_gateway_stage.stage_default.stage_name
  method_path = "*/*"
  settings {
    caching_enabled      = false
    cache_data_encrypted = true
    data_trace_enabled   = false
    metrics_enabled      = var.metrics_enabled
    logging_level        = "ERROR"
  }
}

resource "aws_api_gateway_method_settings" "profile_picture_settings_get" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  stage_name  = aws_api_gateway_stage.stage_default.stage_name
  method_path = "picture/GET"
  settings {
    caching_enabled = false
  }
}

resource "aws_api_gateway_method_settings" "profile_picture_settings_post" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  stage_name  = aws_api_gateway_stage.stage_default.stage_name
  method_path = "picture/POST"
  settings {
    caching_enabled = false
  }
}

output "api_stage_name" {
  value = aws_api_gateway_stage.stage_default.stage_name
}

output "api_invoke_url" {
  value = aws_api_gateway_stage.stage_default.invoke_url
}
