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
variable "api_minimum_compression_size" {
  type        = string
  description = "Tamanho mínimo para compressão de respostas na API Gateway"
}
variable "api_key_name" {
  type        = string
  description = "Nome da chave de API para acesso à API Gateway"
}

variable "cache_cluster_enabled" { type = bool }
variable "cache_cluster_size" { type = number }
variable "api_stage_default_variables" {
  type    = map(any)
  default = {}
}
variable "enable_api_xray" { type = bool }
variable "api_log_retention_in_days" { type = number }
variable "api_quota_settings_limit" { type = string }
variable "api_quota_settings_offset" { type = string }
variable "api_quota_settings_period" { type = string }
variable "api_throttle_settings_burst" { type = string }
variable "api_throttle_settings_rate" { type = string }
variable "metrics_enabled" { type = bool }
