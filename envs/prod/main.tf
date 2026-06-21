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
}
