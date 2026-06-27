data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_canonical_user_id" "current" {}
data "aws_partition" "current" {}

data "aws_servicecatalogappregistry_application" "minhoteca_application" {
  id = var.appregistry_id
}

data "aws_lambda_function" "minhoteca_acervo" {
  function_name = var.lambda_acervo
}

data "aws_cognito_user_pool" "user_pool" {
  user_pool_id = var.cognito_user_pool_id
}
