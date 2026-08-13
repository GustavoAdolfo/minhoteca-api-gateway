# Para forçar o redeploy (string aleatória)
resource "random_string" "random" {
  length  = 20
  special = true
}
resource "random_pet" "server" {}

locals {
  # No Terraform não é possível referenciar recursos internos de módulos filhos.
  # Uma solução mais escalável e de fácil manutenção para o API Gateway é gerar
  # um hash baseado no conteúdo de todos os arquivos .tf de configuração da API.
  api_configuration_json = jsonencode([
    for f in fileset(path.module, "**/*.tf") : filesha1("${path.module}/${f}")
  ])
}

resource "aws_api_gateway_deployment" "api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  lifecycle {
    create_before_destroy = true
  }
  triggers = {
    redeployment = sha1(jsonencode({
      api_config = local.api_configuration_json
      authorizer = aws_api_gateway_authorizer.authorizer.id
      perfil     = aws_api_gateway_method.put_perfilUsuario.id
    }))
  }
}
