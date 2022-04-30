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

variable "use" {
  type = bool
  description = "local"
  default = false
}

variable "ingrss_nginx_lb_ip" {
  type = string
  description = "ingrss_nginx_lb_ip"
}

variable "nsg_common_internet_access_id" {
  type = string
  description = "nsg_common_internet_access_id"
}