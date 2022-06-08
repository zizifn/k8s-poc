
resource "kubernetes_service_account_v1" "otelcontribcol_sa" {
  metadata {
    name      = "otelcontribcol-sa"
    namespace = "default"
    labels = {
      app = "otelcontribcol"
    }
  }
}

resource "kubernetes_cluster_role_v1" "otelcontribcol_role" {
  metadata {
    name = "otelcontribcol"

    labels = {
      app = "otelcontribcol"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["events", "namespaces", "namespaces/status", "nodes", "nodes/spec", "pods", "pods/status", "replicationcontrollers", "replicationcontrollers/status", "resourcequotas", "services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apps"]
    resources  = ["daemonsets", "deployments", "replicasets", "statefulsets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["extensions"]
    resources  = ["daemonsets", "deployments", "replicasets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "otelcontribcol_role_binding" {
  metadata {
    name = "otelcontribcol"

    labels = {
      app = "otelcontribcol"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "otelcontribcol-sa"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "otelcontribcol"
  }
}

resource "kubernetes_config_map_v1" "otel_agent_conf" {
  metadata {
    name      = "otel-agent-conf"
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

resource "kubernetes_daemon_set_v1" "otel_agent" {
  metadata {
    name      = "otel-agent"
    namespace = "default"

    labels = {
      app = "opentelemetry"

      component = "otel-agent"
    }
  }

  spec {
    revision_history_limit = 2
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
        # security_context {
        #   se_linux_options {
        #     level = "s0:c123,c456"
        #   }
        # }
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
        volume {
          name = "cert-volume"

          secret {
            secret_name = "elasticsearch-es-http-certs-public"
          }
        }
        volume {
          name = "varlog"

          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"

          host_path {
            path = "/var/lib/docker/containers"
          }
        }
        service_account_name = kubernetes_service_account_v1.otelcontribcol_sa.metadata[0].name
        container {
          name  = "otel-agent"
          image = "otel/opentelemetry-collector-contrib:0.51.0"
          # command = ["/otelcol", "--config=/conf/otel-agent-config.yaml"]
          args = ["--config", "/conf/otel-agent-config.yaml"]

          port {
            container_port = 55679
          }

          port {
            container_port = 4317 # Default OpenTelemetry receiver port.
          }
          port {
            container_port = 4318 # Default OpenTelemetry receiver http port.
          }

          port {
            container_port = 8888 # Metrics.
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

          env_from {
            secret_ref {
              name = "elasticsearch-es-elastic-user"
            }
          }

          # env_from {
          #   secret_ref {
          #     name = "apm-apm-token"
          #   }
          # }
          # env {
          #   name = "POD_IP"

          #   value_from {
          #     field_ref {
          #       field_path = "status.podIP"
          #     }
          #   }
          # }

          # env {
          #   name  = "OTEL_RESOURCE_ATTRIBUTES"
          #   value = "k8s.pod.ip=$(POD_IP)"
          # }
          env {
            name = "KUBE_NODE_NAME"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "spec.nodeName"
              }
            }
          }
          security_context {
            privileged = true
        }
          volume_mount {
            name       = "otel-agent-config-vol"
            mount_path = "/conf"
          }
          volume_mount {
            name       = "varlog"
            read_only  = true
            mount_path = "/var/log"

        }
          volume_mount {
            name       = "varlibdockercontainers"
            read_only  = true
            mount_path = "/var/lib/docker/containers"
          }
          volume_mount {
            name       = "cert-volume"
            read_only  = true
            mount_path = "/etc/cert-volume"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_cluster_role_binding_v1.otelcontribcol_role_binding
  ]
}

resource "kubernetes_service_v1" "otel_agent_svc" {
  metadata {
    name = "otel-agent-svc"
    labels = {
      app       = "opentelemetry"
      component = "otel-agent"
    }
  }

  spec {
    port {
      name        = "55679"
      port        = 55679
      target_port = 55679
    }
    port {
      name        = "otlp-http"
      port        = 4318
      target_port = 4318
    }
    port {
      name        = "metrics"
      port        = 8888
      target_port = 8888
    }

    selector = {
      component = "otel-agent"
    }
  }
}

