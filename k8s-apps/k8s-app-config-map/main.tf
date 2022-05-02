# terraform {
#   required_providers {
#     oci = {
#       source  = "oracle/oci"
#       version = "~> 4.72.0"
#     }
#   }
# }

resource "kubernetes_config_map_v1" "config_map_ap123456" {
  metadata {
    name = "ap123456"
  }
  data = {
    appid      = "ap123456"
    app_name   = "docker-hello-world"
    dockerimage = "zizifn/ap123456-hello-node:latest"
    # deployment_name = "docker-hello-world-deployment"
    # service_name    = "docker-hello-world-svc"
    container_port       = 3000
    node_port            = null
    svc_port             = 3000
    ingress_path         = "/"
    node_selector        = null
    "my_config_file.yml" = "${file("${path.module}/my_config_file.yml")}"
    ingress_paths = jsonencode(
      [
        {
          path         = "/gtw/hello",
          service_name = "ap123456-docker-hello-world-svc", # "${var.app_id}-${local.app_name}-svc"
          # svc_port = 80 # 可以没有
        }
      ]
    )
  }
  # immutable = true

  # binary_data = {
  #   "my_payload.bin" = "${filebase64("${path.module}/my_payload.bin")}"
  # }
}
