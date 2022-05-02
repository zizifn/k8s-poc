# variable "kube_config_base64" {
#     type = string
#     description = "kube_config_base64"
# }


variable "k8s_host" {
  type        = string
  description = "k8s_host"
}

variable "config_context_auth_info" {
  type        = string
  description = "config_context_auth_info"
}

variable "service_account_token" {
  type        = string
  description = "service_account_token"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "cluster_ca_certificate_base64"
}
