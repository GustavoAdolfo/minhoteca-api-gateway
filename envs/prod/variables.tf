variable "appregistry_id" {
  type        = string
  description = "ID da aplicação no Service Catalog App Registry"
}
variable "lambda_acervo" {
  type        = string
  description = "Nome da função Lambda para o acervo"
}
variable "cognito_user_pool_id" {
  type        = string
  description = "ID do User Pool do Cognito para autenticação na API"
}
variable "api_name" {
  type        = string
  description = "Nome da API Gateway"
}
variable "api_minimum_compression" {
  type        = string
  description = "Tamanho mínimo para compressão de respostas na API Gateway"
}
variable "api_key_name" {
  type        = string
  description = "Nome da chave de API para acesso à API Gateway"
}
