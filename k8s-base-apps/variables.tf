# variable "trun_k8s_init_app" {
#   type = string
#   description = "trun k8s app setup, setup k8s need token .kube/config"
#   default = "OFF"
# }
variable "local" {
  type = bool
  description = "local"
  default = false
}

variable "use_oci_kub_conf_file" {
  type = bool
  description = "local"
  default = false
}
variable "k8s_host" {
  type        = string
  description = "k8s_host"
  default = null
}

variable "config_context_auth_info" {
  type        = string
  description = "config_context_auth_info"
  default = null

}

variable "service_account_token" {
  type        = string
  description = "service_account_token"
  default = null

}

variable "cluster_ca_certificate" {
  type        = string
  description = "cluster_ca_certificate_base64"
  default = null

}

variable "ingrss_nginx_lb_ip" {
  type = string
  description = "ingrss_nginx_lb_ip"
}

variable "nsg_common_internet_access_id" {
  type = string
  description = "nsg_common_internet_access_id"
}