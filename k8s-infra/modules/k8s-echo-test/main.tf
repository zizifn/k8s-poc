# terraform {
#   required_providers {
#     oci = {
#       source  = "oracle/oci"
#       version = "~> 4.109.0"
#     }
#   }
# }
# oci oke
data "oci_containerengine_clusters" "echo_clusters" {
  #Required
  compartment_id = var.compartment_id
}

# oke app
# data "kubernetes_service" "my-ingress-nginx-controller" {
#   metadata {
#     name = "my-ingress-nginx-controller"
#   }
# }


output "echo_k8s" {
  value = data.oci_containerengine_clusters.echo_clusters.clusters[*].name
}

# output "echo_k8s_app" {
#   value = data.kubernetes_service.my-ingress-nginx-controller
# }
