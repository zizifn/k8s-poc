# variable "port" {
#   type        = number
#   description = "port"
#   default     = 8082
# }

# variable "app_id" {
#   type        = string
#   description = "app_id"
#   default     = "ap123456"
# }

# variable "app_env" {
#   type        = string
#   description = "app_name"
#   default     = "value"
# }

# variable "portmaps" {
#   default = [
#     {
#       name   = "derp"
#       number = 1
#     },
#     {
#       name   = "test"
#       number = 2
#     },
#   ]
# }
data "kubernetes_config_map_v1" "configmap" {
  metadata {
    name = "ap123456"
  }
}

locals {
  appid              = sensitive(data.kubernetes_config_map_v1.configmap.data.appid)
  app_name           = sensitive(data.kubernetes_config_map_v1.configmap.data.app_name)
  docker_image       = sensitive(data.kubernetes_config_map_v1.configmap.data.dockerimage)
  deployment_name    = sensitive("${local.appid}-${local.app_name}-deployment")
  service_name       = sensitive("${local.appid}-${local.app_name}-svc")
  ingress_nginx_name = sensitive("ingress-${local.app_name}")
  container_port     = sensitive(try(data.kubernetes_config_map_v1.configmap.data.container_port, null))
  node_port          = sensitive(try(data.kubernetes_config_map_v1.configmap.data.node_port, null))
  svc_port           = sensitive(try(data.kubernetes_config_map_v1.configmap.data.svc_port, null))
  ingress_path       = sensitive(try(data.kubernetes_config_map_v1.configmap.data.ingress_path, null))
  node_selector      = sensitive(try(data.kubernetes_config_map_v1.configmap.data.node_selector, null))
  ingress_paths = try(jsondecode(data.kubernetes_config_map_v1.configmap.data.ingress_paths), [{
    path : "/"
  }])
  # apps = {
  #   "${var.app_id}" = {

  #   }
  # }
}
