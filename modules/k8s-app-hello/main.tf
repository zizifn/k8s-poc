provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_deployment_v1" "docker_hello_world" {
  metadata {
    name = "docker-hello-world-deployment"

    labels = {
      app = "docker-hello-world"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "docker-hello-world"
      }
    }

    template {
      metadata {
        labels = {
          app = "docker-hello-world"
        }
      }

      spec {
        container {
          name  = "docker-hello-world-container"
          image = "scottsbaldwin/docker-hello-world:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "docker_hello_world_svc" {
  metadata {
    name = "docker-hello-world-svc"

    # annotations = {
    #   "oci.oraclecloud.com/load-balancer-type"                      = "lb"
    #   "service.beta.kubernetes.io/oci-load-balancer-shape"          = "flexible"
    #   "service.beta.kubernetes.io/oci-load-balancer-shape-flex-max" = "10"
    #   "service.beta.kubernetes.io/oci-load-balancer-shape-flex-min" = "10"
    # }
  }

  spec {
    port {
      port        = 80
      target_port = "80"
    }

    selector = {
      app = "docker-hello-world"
    }

    type = "NodePort"
  }
}

resource "kubernetes_manifest" "ingress_docker_hello_world" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind" = "Ingress"
    "metadata" = {
      "name" = "ingress-docker-hello-world"
      "namespace" = "default"
    }
    "spec" = {
      "ingressClassName" = "nginx"
      "rules" = [
        {
          "http" = {
            "paths" = [
              {
                "backend" = {
                  "service" = {
                    "name" = "docker-hello-world-svc"
                    "port" = {
                      "number" = 80
                    }
                  }
                }
                "path" = "/"
                "pathType" = "Prefix"
              },
            ]
          }
        },
      ]
    }
  }
}
