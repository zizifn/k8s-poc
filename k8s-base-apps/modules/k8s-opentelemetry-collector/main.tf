resource "kubernetes_config_map_v1" "opentelemetry_k8s" {
  metadata {
    name = "opentelemetry_collector_k8s"
  }

  data = {
    "opentelemetry_k8s.yml" = "${file("${path.module}/data/opentelemetry_k8s.yml")}"
  }

}

resource "kubernetes_deployment" "otelcontribcol_k8s" {
  metadata {
    name = "otelcontribcol_k8s"

    labels = {
      app = "otelcontribcol_k8s"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "otelcontribcol_k8s"
      }
    }

    template {
      metadata {
        labels = {
          app = "otelcontribcol_k8s"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "opentelemetry_collector_k8s"
          }
        }

        container {
          name  = "otelcontribcol"
          image = "otel/opentelemetry-collector-contrib:latest"
          args  = ["--config", "/etc/config/opentelemetry_k8s.yaml"]

          volume_mount {
            name       = "config"
            mount_path = "/etc/config"
          }
        }
        service_account_name = "otelcontribcol-sa"
      }
    }
  }

  depends_on = [
    kubernetes_config_map_v1.opentelemetry_k8s
  ]
}
