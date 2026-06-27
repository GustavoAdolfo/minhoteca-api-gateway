locals {
  account_id               = data.aws_caller_identity.current.account_id
  region                   = data.aws_region.current.name
  user_id                  = data.aws_canonical_user_id.current.id
  application_tags         = data.aws_servicecatalogappregistry_application.minhoteca_application.tags
  lambda_acervo_arn        = data.aws_lambda_function.minhoteca_acervo.arn
  lambda_acervo_invoke_arn = data.aws_lambda_function.minhoteca_acervo.invoke_arn
  cognito_user_pool_arn    = data.aws_cognito_user_pool.user_pool.arn
}
