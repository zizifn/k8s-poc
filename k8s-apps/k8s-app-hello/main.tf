# terraform {
#   required_providers {
#     oci = {
#       source  = "oracle/oci"
#       version = "~> 4.72.0"
#     }
#   }
# }
resource "kubernetes_deployment_v1" "k8s_deployment" {
  for_each = local.apps # 循环
  metadata {
    # name = "docker-hello-world-deployment"
    name = each.value.deployment_name


    labels = {
      # app = "docker-hello-world"
      app   = each.key
      appid = each.value.appid
    }
  }

  spec {
    replicas               = 2
    revision_history_limit = 4

    selector {
      match_labels = {
        # app = "docker-hello-world"
        app = each.key
      }
    }

    template {
      metadata {
        labels = {
          # app = "docker-hello-world"
          app   = each.key
          appid = each.value.appid
        }
      }

      spec {
        container {
          name  = each.key
          image = each.value.docker_image

          port {
            container_port = each.value.container_port
          }
          env_from {
            secret_ref {
              name = "ap123456"
            }
          }
        }
        node_selector = each.value.node_selector

      }

    }
  }
}
resource "kubernetes_service_v1" "k8s_svc" {
  for_each = local.apps # 循环
  metadata {
    name = each.value.service_name
    labels = {
      appid = each.value.appid
    }
  }

  spec {
    port {
      port        = each.value.svc_port
      target_port = each.value.container_port
      node_port   = each.value.node_port
    }

    selector = {
      app = each.key
    }

    type = "NodePort"
  }
}
resource "kubernetes_ingress_v1" "nginx_ingress" {
  for_each = local.apps # 循环
  metadata {
    name      = each.value.ingress_nginx_name
    namespace = "default"
    labels = {
      appid = each.value.appid
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        dynamic "path" { # 循环
          for_each = each.value.ingress_paths
          content { # content 是关键字，必须有
            backend {
              service {
                name = try(path.value.service_name, each.value.service_name)
                port {
                  number = try(path.value.svc_port, each.value.svc_port)
                }
              }
            }

            path = path.value.path
          }

        }
      }
    }
  }

}
