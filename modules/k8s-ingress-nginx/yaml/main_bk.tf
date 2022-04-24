provider "kubernetes" {
  config_path    = "~/.kube/config"
}
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"

    labels = {
      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"
    }
  }
}

resource "kubernetes_service_account" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  automount_service_account_token = true
}

resource "kubernetes_service_account" "ingress_nginx_admission" {
  metadata {
    name      = "ingress-nginx-admission"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }
}

resource "kubernetes_role" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["namespaces"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "pods", "secrets", "endpoints"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingressclasses"]
  }

  rule {
    verbs          = ["get", "update"]
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["ingress-controller-leader"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }
}

resource "kubernetes_role" "ingress_nginx_admission" {
  metadata {
    name      = "ingress-nginx-admission"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  rule {
    verbs      = ["get", "create"]
    api_groups = [""]
    resources  = ["secrets"]
  }
}

resource "kubernetes_cluster_role" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"

    labels = {
      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "nodes", "pods", "secrets", "namespaces"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingressclasses"]
  }
}

resource "kubernetes_cluster_role" "ingress_nginx_admission" {
  metadata {
    name = "ingress-nginx-admission"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  rule {
    verbs      = ["get", "update"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations"]
  }
}

resource "kubernetes_role_binding" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx"
    namespace = "ingress-nginx"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "ingress-nginx"
  }
}

resource "kubernetes_role_binding" "ingress_nginx_admission" {
  metadata {
    name      = "ingress-nginx-admission"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx-admission"
    namespace = "ingress-nginx"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "ingress-nginx-admission"
  }
}

resource "kubernetes_cluster_role_binding" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"

    labels = {
      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx"
    namespace = "ingress-nginx"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "ingress-nginx"
  }
}

resource "kubernetes_cluster_role_binding" "ingress_nginx_admission" {
  metadata {
    name = "ingress-nginx-admission"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx-admission"
    namespace = "ingress-nginx"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "ingress-nginx-admission"
  }
}

resource "kubernetes_config_map" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  data = {
    allow-snippet-annotations = "true"
  }
}

resource "kubernetes_service" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }

    annotations = {
      "oci.oraclecloud.com/load-balancer-type" = "lb"

      "service.beta.kubernetes.io/oci-load-balancer-shape" = "flexible"

      "service.beta.kubernetes.io/oci-load-balancer-shape-flex-max" = "10"

      "service.beta.kubernetes.io/oci-load-balancer-shape-flex-min" = "10"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = "http"
    }

    port {
      name        = "https"
      protocol    = "TCP"
      port        = 443
      target_port = "https"
    }

    selector = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"
    }

    type                    = "LoadBalancer"
    external_traffic_policy = "Local"
  }
}

resource "kubernetes_service" "ingress_nginx_controller_admission" {
  metadata {
    name      = "ingress-nginx-controller-admission"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  spec {
    port {
      name        = "https-webhook"
      port        = 443
      target_port = "webhook"
    }

    selector = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "controller"

        "app.kubernetes.io/instance" = "ingress-nginx"

        "app.kubernetes.io/name" = "ingress-nginx"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "controller"

          "app.kubernetes.io/instance" = "ingress-nginx"

          "app.kubernetes.io/name" = "ingress-nginx"
        }
      }

      spec {
        volume {
          name = "webhook-cert"

          secret {
            secret_name = "ingress-nginx-admission"
          }
        }

        container {
          name  = "controller"
          image = "k8s.gcr.io/ingress-nginx/controller:v1.2.0@sha256:d8196e3bc1e72547c5dec66d6556c0ff92a23f6d0919b206be170bc90d5f9185"
          args  = ["/nginx-ingress-controller", "--publish-service=$(POD_NAMESPACE)/ingress-nginx-controller", "--election-id=ingress-controller-leader", "--controller-class=k8s.io/ingress-nginx", "--ingress-class=nginx", "--configmap=$(POD_NAMESPACE)/ingress-nginx-controller", "--validating-webhook=:8443", "--validating-webhook-certificate=/usr/local/certificates/cert", "--validating-webhook-key=/usr/local/certificates/key"]

          port {
            name           = "http"
            container_port = 80
            protocol       = "TCP"
          }

          port {
            name           = "https"
            container_port = 443
            protocol       = "TCP"
          }

          port {
            name           = "webhook"
            container_port = 8443
            protocol       = "TCP"
          }

          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name  = "LD_PRELOAD"
            value = "/usr/local/lib/libmimalloc.so"
          }

          resources {
            requests = {
              cpu = "100m"

              memory = "90Mi"
            }
          }

          volume_mount {
            name       = "webhook-cert"
            read_only  = true
            mount_path = "/usr/local/certificates/"
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          lifecycle {
            pre_stop {
              exec {
                command = ["/wait-shutdown"]
              }
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              add  = ["NET_BIND_SERVICE"]
              drop = ["ALL"]
            }

            run_as_user                = 101
            allow_privilege_escalation = true
          }
        }

        termination_grace_period_seconds = 300
        dns_policy                       = "ClusterFirst"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "ingress-nginx"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_job" "ingress_nginx_admission_create" {
  metadata {
    name      = "ingress-nginx-admission-create"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  spec {
    template {
      metadata {
        name = "ingress-nginx-admission-create"

        labels = {
          "app.kubernetes.io/component" = "admission-webhook"

          "app.kubernetes.io/instance" = "ingress-nginx"

          "app.kubernetes.io/name" = "ingress-nginx"

          "app.kubernetes.io/part-of" = "ingress-nginx"

          "app.kubernetes.io/version" = "1.2.0"
        }
      }

      spec {
        container {
          name  = "create"
          image = "k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660"
          args  = ["create", "--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc", "--namespace=$(POD_NAMESPACE)", "--secret-name=ingress-nginx-admission"]

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          image_pull_policy = "IfNotPresent"
        }

        restart_policy = "OnFailure"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "ingress-nginx-admission"

        security_context {
          run_as_user     = 2000
          run_as_non_root = true
          fs_group        = 2000
        }
      }
    }
  }
}

resource "kubernetes_job" "ingress_nginx_admission_patch" {
  metadata {
    name      = "ingress-nginx-admission-patch"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  spec {
    template {
      metadata {
        name = "ingress-nginx-admission-patch"

        labels = {
          "app.kubernetes.io/component" = "admission-webhook"

          "app.kubernetes.io/instance" = "ingress-nginx"

          "app.kubernetes.io/name" = "ingress-nginx"

          "app.kubernetes.io/part-of" = "ingress-nginx"

          "app.kubernetes.io/version" = "1.2.0"
        }
      }

      spec {
        container {
          name  = "patch"
          image = "k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660"
          args  = ["patch", "--webhook-name=ingress-nginx-admission", "--namespace=$(POD_NAMESPACE)", "--patch-mutating=false", "--secret-name=ingress-nginx-admission", "--patch-failure-policy=Fail"]

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          image_pull_policy = "IfNotPresent"
        }

        restart_policy = "OnFailure"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "ingress-nginx-admission"

        security_context {
          run_as_user     = 2000
          run_as_non_root = true
          fs_group        = 2000
        }
      }
    }
  }
}

resource "kubernetes_ingress_class" "nginx" {
  metadata {
    name = "nginx"

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  spec {
    controller = "k8s.io/ingress-nginx"
  }
}

resource "kubernetes_validating_webhook_configuration" "ingress_nginx_admission" {
  metadata {
    name = "ingress-nginx-admission"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.0"
    }
  }

  webhook {
    name = "validate.nginx.ingress.kubernetes.io"

    client_config {
      service {
        namespace = "ingress-nginx"
        name      = "ingress-nginx-controller-admission"
        path      = "/networking/v1/ingresses"
      }
    }

    rule {
      api_groups = ["networking.k8s.io"]
      resources  = ["ingresses"]
      operations = ["CREATE", "UPDATE"]
      api_versions = ["v1"]
    }

    failure_policy            = "Fail"
    match_policy              = "Equivalent"
    side_effects              = "None"
    admission_review_versions = ["v1"]
  }
}

