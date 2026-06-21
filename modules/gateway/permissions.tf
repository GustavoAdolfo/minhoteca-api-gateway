# resource "aws_lambda_permission" "apigw_userService" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = var.lambda_user_service_arn
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_api_gateway_rest_api.api_minhoteca.execution_arn}/*/*"
# }

# resource "aws_lambda_permission" "apigw_adminService" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = var.lambda_admin_arn
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_api_gateway_rest_api.api_minhoteca.execution_arn}/*/*"
# }

resource "aws_lambda_permission" "apigw_acervo" {
  statement_id  = "AllowExecutionAcervoAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_acervo_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_minhoteca.execution_arn}/*/*"
}
