terraform {
  required_version = "~> 1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Terraform = true
      Projeto   = "Minhoteca"
    }
  }
}

module "gateway" {
  source                       = "../../modules/gateway"
  application_tags             = local.application_tags
  api_minimum_compression_size = var.api_minimum_compression_size
  api_name                     = var.api_name
  api_key_name                 = var.api_key_name
  cognito_user_pool_arn        = local.cognito_user_pool_arn
  lambda_acervo_arn            = local.lambda_acervo_arn
  cache_cluster_enabled        = var.cache_cluster_enabled
  cache_cluster_size           = var.cache_cluster_size
  api_stage_default_variables  = var.api_stage_default_variables
  enable_api_xray              = var.enable_api_xray
  api_log_retention_in_days    = var.api_log_retention_in_days
  api_quota_settings_limit     = var.api_quota_settings_limit
  api_quota_settings_offset    = var.api_quota_settings_offset
  api_quota_settings_period    = var.api_quota_settings_period
  api_throttle_settings_burst  = var.api_throttle_settings_burst
  api_throttle_settings_rate   = var.api_throttle_settings_rate
  metrics_enabled              = var.metrics_enabled
}
