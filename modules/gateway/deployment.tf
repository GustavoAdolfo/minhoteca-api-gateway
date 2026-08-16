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

locals {
  api_gateway_method_ids = [
    aws_api_gateway_method.cors_method.id,
    aws_api_gateway_method.cors_v1.id,
    aws_api_gateway_method.optionsAutor_method.id,
    aws_api_gateway_method.getAutor_method.id,
    aws_api_gateway_method.options_getAutores.id,
    aws_api_gateway_method.getAutores_method.id,
    aws_api_gateway_method.gateway_optionsLivro_method.id,
    aws_api_gateway_method.getLivro_method.id,
    aws_api_gateway_method.options_getLivros.id,
    aws_api_gateway_method.getLivros_method.id,
    aws_api_gateway_method.perfilFoto_method_options.id,
    aws_api_gateway_method.post_perfilFoto.id,
    aws_api_gateway_method.get_perfilUsuario.id,
    aws_api_gateway_method.put_perfilUsuario.id,
    aws_api_gateway_method.perfilUsuario_method_options.id,
    aws_api_gateway_method.root_method_get.id,
    aws_api_gateway_method.root_method_options.id,
    aws_api_gateway_method.getEstatisticas_method.id,
    aws_api_gateway_method.options_getEstatisticas.id,
  ]

  api_gateway_integration_ids = [
    aws_api_gateway_integration.cors_integration.id,
    aws_api_gateway_integration.cors_v1.id,
    aws_api_gateway_integration.gateway_getLivro_integration.id,
    aws_api_gateway_integration.getAutores_integration.id,
    aws_api_gateway_integration.getAutor_integration.id,
    aws_api_gateway_integration.getLivro_integration.id,
    aws_api_gateway_integration.getLivros_integration.id,
    aws_api_gateway_integration.get_perfilUsuario_integration.id,
    aws_api_gateway_integration.optionsAutor_integration.id,
    aws_api_gateway_integration.options_getAutores_integration.id,
    aws_api_gateway_integration.options_getLivros_integration.id,
    aws_api_gateway_integration.perfilFoto_options_integration.id,
    aws_api_gateway_integration.perfilUsuario_options_integration.id,
    aws_api_gateway_integration.post_perfilFoto_integration.id,
    aws_api_gateway_integration.put_perfilUsuario_integration.id,
    aws_api_gateway_integration.root_get_integration.id,
    aws_api_gateway_integration.root_options_integration.id,
    aws_api_gateway_integration.getEstatisticas_integration.id,
    aws_api_gateway_integration.options_getEstatisticas_integration.id,
  ]
}

resource "aws_api_gateway_deployment" "api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode({
      api_config   = local.api_configuration_json
      authorizer   = aws_api_gateway_authorizer.authorizer.id
      methods      = local.api_gateway_method_ids
      integrations = local.api_gateway_integration_ids
    }))
  }
}
