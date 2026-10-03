resource "aws_api_gateway_resource" "admin_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.resource_v1.id
  path_part   = "admin"
}

resource "aws_api_gateway_resource" "admin_editoras_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "editoras"
}

resource "aws_api_gateway_resource" "admin_autores_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "autores"
}

resource "aws_api_gateway_resource" "admin_livros_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "livros"
}

resource "aws_api_gateway_resource" "admin_paises_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "paises"
}

resource "aws_api_gateway_resource" "admin_editora_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "editora"
}

resource "aws_api_gateway_resource" "admin_autor_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "autor"
}

resource "aws_api_gateway_resource" "admin_livro_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "livro"
}


resource "aws_api_gateway_resource" "admin_pais_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "pais"
}

resource "aws_api_gateway_resource" "admin_editora_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_editora_resource.id
  path_part   = "{id}"
}

resource "aws_api_gateway_resource" "admin_autor_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_autor_resource.id
  path_part   = "{id}"
}

resource "aws_api_gateway_resource" "admin_livro_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_minhoteca.id
  parent_id   = aws_api_gateway_resource.admin_livro_resource.id
  path_part   = "{id}"
}
