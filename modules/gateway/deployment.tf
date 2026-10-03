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
    aws_api_gateway_method.gateway_optionsLivro_emprestimo_method.id,
    aws_api_gateway_method.getLivro_emprestimo_method.id,
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
    aws_api_gateway_method.get_emprestar.id,
    aws_api_gateway_method.post_emprestar.id,
    aws_api_gateway_method.emprestar_method_options.id,
    aws_api_gateway_method.options_admin_editoras.id,
    aws_api_gateway_method.get_admin_editoras_method.id,
    aws_api_gateway_method.options_admin_autores.id,
    aws_api_gateway_method.get_admin_autores_method.id,
    aws_api_gateway_method.options_admin_livros.id,
    aws_api_gateway_method.get_admin_livros_method.id,
    aws_api_gateway_method.options_admin_paises.id,
    aws_api_gateway_method.get_admin_paises_method.id,
    aws_api_gateway_method.options_admin_livro.id,
    aws_api_gateway_method.get_admin_livro_method.id,
    aws_api_gateway_method.options_admin_livro_post.id,
    aws_api_gateway_method.post_admin_livro_method.id,
    aws_api_gateway_method.put_admin_livro_method.id,
    aws_api_gateway_model.admin_livro_put_request_model.id,
    aws_api_gateway_request_validator.admin_livro_put_request_validator.id,
    aws_api_gateway_model.admin_livro_post_request_model.id,
    aws_api_gateway_request_validator.admin_livro_post_request_validator.id,
    aws_api_gateway_method.options_admin_autor.id,
    aws_api_gateway_method.get_admin_autor_method.id,
    aws_api_gateway_method.options_admin_autor_post.id,
    aws_api_gateway_method.post_admin_autor_method.id,
    aws_api_gateway_method.put_admin_autor_method.id,
    aws_api_gateway_model.admin_autor_put_request_model.id,
    aws_api_gateway_request_validator.admin_autor_put_request_validator.id,
    aws_api_gateway_model.admin_autor_post_request_model.id,
    aws_api_gateway_request_validator.admin_autor_post_request_validator.id,
    aws_api_gateway_method.options_admin_editora.id,
    aws_api_gateway_method.get_admin_editora_method.id,
    aws_api_gateway_method.options_admin_editora_post.id,
    aws_api_gateway_method.post_admin_editora_method.id,
    aws_api_gateway_method.put_admin_editora_method.id,
    aws_api_gateway_model.admin_editora_put_request_model.id,
    aws_api_gateway_request_validator.admin_editora_put_request_validator.id,
    aws_api_gateway_model.admin_editora_post_request_model.id,
    aws_api_gateway_request_validator.admin_editora_post_request_validator.id,
  ]

  api_gateway_integration_ids = [
    aws_api_gateway_integration.cors_integration.id,
    aws_api_gateway_integration.cors_v1.id,
    aws_api_gateway_integration.gateway_getLivro_integration.id,
    aws_api_gateway_integration.gateway_getLivro_emprestimo_integration.id,
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
    aws_api_gateway_integration.get_emprestar_integration.id,
    aws_api_gateway_integration.post_emprestar_integration.id,
    aws_api_gateway_integration.emprestar_options_integration.id,
    aws_api_gateway_integration.options_admin_editoras_integration.id,
    aws_api_gateway_integration.get_admin_editoras_integration.id,
    aws_api_gateway_integration.options_admin_autores_integration.id,
    aws_api_gateway_integration.get_admin_autores_integration.id,
    aws_api_gateway_integration.options_admin_livros_integration.id,
    aws_api_gateway_integration.get_admin_livros_integration.id,
    aws_api_gateway_integration.options_admin_paises_integration.id,
    aws_api_gateway_integration.get_admin_paises_integration.id,
    aws_api_gateway_integration.options_admin_livro_integration.id,
    aws_api_gateway_integration.get_admin_livro_integration.id,
    aws_api_gateway_integration.options_admin_livro_post_integration.id,
    aws_api_gateway_integration.post_admin_livro_integration.id,
    aws_api_gateway_integration.put_admin_livro_integration.id,
    aws_api_gateway_integration.options_admin_autor_integration.id,
    aws_api_gateway_integration.get_admin_autor_integration.id,
    aws_api_gateway_integration.options_admin_autor_post_integration.id,
    aws_api_gateway_integration.post_admin_autor_integration.id,
    aws_api_gateway_integration.put_admin_autor_integration.id,
    aws_api_gateway_integration.options_admin_editora_integration.id,
    aws_api_gateway_integration.get_admin_editora_integration.id,
    aws_api_gateway_integration.options_admin_editora_post_integration.id,
    aws_api_gateway_integration.post_admin_editora_integration.id,
    aws_api_gateway_integration.put_admin_editora_integration.id,
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
