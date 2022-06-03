resource "kubernetes_config_map" "otel_agent_conf" {
  metadata {
    name = "otel-agent-conf"
    namespace = "default"

    labels = {
      app = "opentelemetry"

      component = "otel-agent-conf"
    }
  }

  data = {
    otel-agent-config = "${file("${path.module}/data/opentelemetry_k8s.yaml")}"
  }
}

resource "kubernetes_daemonset" "otel_agent" {
  metadata {
    name = "otel-agent"
    namespace = "default"

    labels = {
      app = "opentelemetry"

      component = "otel-agent"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "opentelemetry"

        component = "otel-agent"
      }
    }

    template {
      metadata {
        labels = {
          app = "opentelemetry"

          component = "otel-agent"
        }
      }

      spec {
        volume {
          name = "otel-agent-config-vol"

          config_map {
            name = "otel-agent-conf"

            items {
              key  = "otel-agent-config"
              path = "otel-agent-config.yaml"
            }
          }
        }
        service_account_name = "otelcontribcol-sa"
        container {
          name    = "otel-agent"
          image   = "otel/opentelemetry-collector-contrib:0.51.0"
          # command = ["/otelcol", "--config=/conf/otel-agent-config.yaml"]
          args = ["--config", "/conf/otel-agent-config.yaml"]

          port {
            container_port = 55679
          }

          port {
            container_port = 4317 # Default OpenTelemetry receiver port.
          }

          port {
            container_port = 8888  # Metrics.
          }

          resources {
            limits = {
              cpu = "500m"

              memory = "500Mi"
            }

            requests = {
              cpu = "100m"

              memory = "100Mi"
            }
          }

          volume_mount {
            name       = "otel-agent-config-vol"
            mount_path = "/conf"
          }
        }
      }
    }
  }
}


