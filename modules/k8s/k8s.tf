provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_deployment" "docker_hello_world" {
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

resource "kubernetes_service" "docker_hello_world_svc" {
  metadata {
    name = "docker-hello-world-svc"

    annotations = {
      "oci.oraclecloud.com/load-balancer-type"                      = "lb"
      "service.beta.kubernetes.io/oci-load-balancer-shape"          = "flexible"
      "service.beta.kubernetes.io/oci-load-balancer-shape-flex-max" = "10"
      "service.beta.kubernetes.io/oci-load-balancer-shape-flex-min" = "10"
    }
  }

  spec {
    port {
      port        = 8088
      target_port = "80"
    }

    selector = {
      app = "docker-hello-world"
    }

    type = "LoadBalancer"
  }
}
