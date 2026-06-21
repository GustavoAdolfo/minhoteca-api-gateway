variable "application_tags" { type = map(string) }
variable "api_minimum_compression_size" { type = string }
variable "api_name" { type = string }
variable "api_key_name" { type = string }
variable "cognito_user_pool_arn" { type = string }
variable "lambda_acervo_arn" { type = string }

variable "cache_cluster_enabled" { type = bool }
variable "cache_cluster_size" { type = number }
variable "api_stage_default_variables" { type = map(any) }
variable "enable_api_xray" { type = bool }
variable "api_log_retention_in_days" { type = number }
variable "api_quota_settings_limit" { type = string }
variable "api_quota_settings_offset" { type = string }
variable "api_quota_settings_period" { type = string }
variable "api_throttle_settings_burst" { type = string }
variable "api_throttle_settings_rate" { type = string }
variable "metrics_enabled" { type = bool }
