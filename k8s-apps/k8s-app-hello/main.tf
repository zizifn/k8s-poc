resource "kubernetes_secret_v1" "secret_ap123456" {
  metadata {
    name = "ap123456"
  }

  data = {
    testvar = "test111"
    testfile     = "${file("${path.module}/data/test.txt")}"
    testjson = jsonencode({
      test1 = 333444 # can use hcl syntax
    }) # eyJ0ZXN0MSI6MzMzfQ==
  }
  # immutable = true  如果设置了这个，需要整个deploment 删除，然后重新创建
  type = "Opaque"
}

resource "kubernetes_deployment_v1" "k8s_deployment_ap123456" {
  # # for_each = local.apps # 循环
  metadata {
    # name = "docker-hello-world-deployment"
    name = local.deployment_name


    labels = {
      # app = "docker-hello-world"
      app   = local.appid
      appid = local.appid
    }
  }

  spec {
    replicas               = 2
    revision_history_limit = 4

    selector {
      match_labels = {
        # app = "docker-hello-world"
        app = local.appid
      }
    }
    # strategy {
    #   type = "Recreate"
    # }

    template {
      metadata {
        labels = {
          # app = "docker-hello-world"
          app   = local.appid
          appid = local.appid
        }
      }

      spec {
        container {
          name  = local.appid
          image = local.docker_image

          port {
            container_port = local.container_port
          }
          env_from {
            secret_ref {
              name = "ap123456"
            }
          }
        }
        node_selector = local.node_selector


      }

    }
  }

  depends_on = [
    kubernetes_secret_v1.secret_ap123456
  ]
}
resource "kubernetes_service_v1" "k8s_svc" {
  # for_each = local.apps # 循环
  metadata {
    name = local.service_name
    labels = {
      appid = local.appid
    }
  }

  spec {
    port {
      port        = local.svc_port
      target_port = local.container_port
      node_port   = local.node_port
    }

    selector = {
      app = local.appid
    }

    type = "NodePort"
  }
}
resource "kubernetes_ingress_v1" "nginx_ingress" {
  # for_each = local.apps # 循环
  metadata {
    name      = local.ingress_nginx_name
    namespace = "default"
    labels = {
      appid = local.appid
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        dynamic "path" { # 循环
          for_each = local.ingress_paths
          content { # content 是关键字，必须有
            backend {
              service {
                name = try(path.value.service_name, local.service_name)
                port {
                  number = try(path.value.svc_port, local.svc_port)
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
