resource "kubernetes_namespace" "elastic_system" {
  metadata {
    name = "elastic-system"

    labels = {
      name = "elastic-system"
    }
  }
}

resource "kubernetes_service_account" "elastic_operator" {
  metadata {
    name      = "elastic-operator"
    namespace = "elastic-system"

    labels = {
      "app.kubernetes.io/version" = "2.2.0"

      control-plane = "elastic-operator"
    }
  }
}

resource "kubernetes_secret" "elastic_webhook_server_cert" {
  metadata {
    name      = "elastic-webhook-server-cert"
    namespace = "elastic-system"

    labels = {
      "app.kubernetes.io/version" = "2.2.0"

      control-plane = "elastic-operator"
    }
  }
}

resource "kubernetes_config_map" "elastic_operator" {
  metadata {
    name      = "elastic-operator"
    namespace = "elastic-system"

    labels = {
      "app.kubernetes.io/version" = "2.2.0"

      control-plane = "elastic-operator"
    }
  }

  data = {
    "eck.yaml" = "log-verbosity: 0\nmetrics-port: 0\ncontainer-registry: docker.elastic.co\nmax-concurrent-reconciles: 3\nca-cert-validity: 8760h\nca-cert-rotate-before: 24h\ncert-validity: 8760h\ncert-rotate-before: 24h\nexposed-node-labels: [topology.kubernetes.io/.*,failure-domain.beta.kubernetes.io/.*]\nset-default-security-context: auto-detect\nkube-client-timeout: 60s\nelasticsearch-client-timeout: 180s\ndisable-telemetry: false\ndistribution-channel: all-in-one\nvalidate-storage-class: true\nenable-webhook: true\nwebhook-name: elastic-webhook.k8s.elastic.co"
  }
}

resource "kubernetes_cluster_role" "elastic_operator" {
  metadata {
    name = "elastic-operator"

    labels = {
      "app.kubernetes.io/version" = "2.2.0"

      control-plane = "elastic-operator"
    }
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["endpoints"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
    api_groups = [""]
    resources  = ["pods", "events", "persistentvolumeclaims", "secrets", "services", "configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets", "daemonsets"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
    api_groups = ["elasticsearch.k8s.elastic.co"]
    resources  = ["elasticsearches", "elasticsearches/status", "elasticsearches/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
    api_groups = ["kibana.k8s.elastic.co"]
    resources  = ["kibanas", "kibanas/status", "kibanas/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
    api_groups = ["apm.k8s.elastic.co"]
    resources  = ["apmservers", "apmservers/status", "apmservers/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
    api_groups = ["enterprisesearch.k8s.elastic.co"]
    resources  = ["enterprisesearches", "enterprisesearches/status", "enterprisesearches/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
    api_groups = ["beat.k8s.elastic.co"]
    resources  = ["beats", "beats/status", "beats/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
    api_groups = ["agent.k8s.elastic.co"]
    resources  = ["agents", "agents/status", "agents/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
    api_groups = ["maps.k8s.elastic.co"]
    resources  = ["elasticmapsservers", "elasticmapsservers/status", "elasticmapsservers/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes"]
  }
}

resource "kubernetes_cluster_role" "elastic_operator_view" {
  metadata {
    name = "elastic-operator-view"

    labels = {
      "app.kubernetes.io/version" = "2.2.0"

      control-plane = "elastic-operator"

      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"

      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"

      "rbac.authorization.k8s.io/aggregate-to-view" = "true"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["elasticsearch.k8s.elastic.co"]
    resources  = ["elasticsearches"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apm.k8s.elastic.co"]
    resources  = ["apmservers"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["kibana.k8s.elastic.co"]
    resources  = ["kibanas"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["enterprisesearch.k8s.elastic.co"]
    resources  = ["enterprisesearches"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["beat.k8s.elastic.co"]
    resources  = ["beats"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["agent.k8s.elastic.co"]
    resources  = ["agents"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["maps.k8s.elastic.co"]
    resources  = ["elasticmapsservers"]
  }
}

resource "kubernetes_cluster_role" "elastic_operator_edit" {
  metadata {
    name = "elastic-operator-edit"

    labels = {
      "app.kubernetes.io/version" = "2.2.0"

      control-plane = "elastic-operator"

      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"

      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
    }
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "patch", "update"]
    api_groups = ["elasticsearch.k8s.elastic.co"]
    resources  = ["elasticsearches"]
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "patch", "update"]
    api_groups = ["apm.k8s.elastic.co"]
    resources  = ["apmservers"]
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "patch", "update"]
    api_groups = ["kibana.k8s.elastic.co"]
    resources  = ["kibanas"]
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "patch", "update"]
    api_groups = ["enterprisesearch.k8s.elastic.co"]
    resources  = ["enterprisesearches"]
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "patch", "update"]
    api_groups = ["beat.k8s.elastic.co"]
    resources  = ["beats"]
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "patch", "update"]
    api_groups = ["agent.k8s.elastic.co"]
    resources  = ["agents"]
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "patch", "update"]
    api_groups = ["maps.k8s.elastic.co"]
    resources  = ["elasticmapsservers"]
  }
}

resource "kubernetes_cluster_role_binding" "elastic_operator" {
  metadata {
    name = "elastic-operator"

    labels = {
      "app.kubernetes.io/version" = "2.2.0"

      control-plane = "elastic-operator"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "elastic-operator"
    namespace = "elastic-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "elastic-operator"
  }
}

resource "kubernetes_service" "elastic_webhook_server" {
  metadata {
    name      = "elastic-webhook-server"
    namespace = "elastic-system"

    labels = {
      "app.kubernetes.io/version" = "2.2.0"

      control-plane = "elastic-operator"
    }
  }

  spec {
    port {
      name        = "https"
      port        = 443
      target_port = "9443"
    }

    selector = {
      control-plane = "elastic-operator"
    }
  }
}

resource "kubernetes_stateful_set" "elastic_operator" {
  metadata {
    name      = "elastic-operator"
    namespace = "elastic-system"

    labels = {
      "app.kubernetes.io/version" = "2.2.0"

      control-plane = "elastic-operator"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        control-plane = "elastic-operator"
      }
    }

    template {
      metadata {
        labels = {
          control-plane = "elastic-operator"
        }

        annotations = {
          "checksum/config" = "302bbb79b6fb0ffa41fcc06e164252c7dad887cf4d8149c8e1e5203c7651277e"

          "co.elastic.logs/raw" = "[{\"type\":\"container\",\"json.keys_under_root\":true,\"paths\":[\"/var/log/containers/*$${data.kubernetes.container.id}.log\"],\"processors\":[{\"convert\":{\"mode\":\"rename\",\"ignore_missing\":true,\"fields\":[{\"from\":\"error\",\"to\":\"_error\"}]}},{\"convert\":{\"mode\":\"rename\",\"ignore_missing\":true,\"fields\":[{\"from\":\"_error\",\"to\":\"error.message\"}]}},{\"convert\":{\"mode\":\"rename\",\"ignore_missing\":true,\"fields\":[{\"from\":\"source\",\"to\":\"_source\"}]}},{\"convert\":{\"mode\":\"rename\",\"ignore_missing\":true,\"fields\":[{\"from\":\"_source\",\"to\":\"event.source\"}]}}]}]"
        }
      }

      spec {
        volume {
          name = "conf"

          config_map {
            name = "elastic-operator"
          }
        }

        volume {
          name = "cert"

          secret {
            secret_name  = "elastic-webhook-server-cert"
            default_mode = "0644"
          }
        }

        container {
          name  = "manager"
          image = "docker.elastic.co/eck/eck-operator:2.2.0"
          args  = ["manager", "--config=/conf/eck.yaml"]

          port {
            name           = "https-webhook"
            container_port = 9443
            protocol       = "TCP"
          }

          env {
            name = "OPERATOR_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "POD_IP"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name  = "WEBHOOK_SECRET"
            value = "elastic-webhook-server-cert"
          }

          resources {
            limits = {
              cpu = "1"

              memory = "1Gi"
            }

            requests = {
              cpu = "100m"

              memory = "150Mi"
            }
          }

          volume_mount {
            name       = "conf"
            read_only  = true
            mount_path = "/conf"
          }

          volume_mount {
            name       = "cert"
            read_only  = true
            mount_path = "/tmp/k8s-webhook-server/serving-certs"
          }

          image_pull_policy = "IfNotPresent"
        }

        termination_grace_period_seconds = 10
        service_account_name             = "elastic-operator"

        security_context {
          run_as_non_root = true
        }
      }
    }

    service_name = "elastic-operator"
  }
}

resource "kubernetes_validating_webhook_configuration" "elastic_webhook.k_8_s.elastic.co" {
  metadata {
    name = "elastic-webhook.k8s.elastic.co"

    labels = {
      "app.kubernetes.io/version" = "2.2.0"

      control-plane = "elastic-operator"
    }
  }

  webhook {
    name = "elastic-agent-validation-v1alpha1.k8s.elastic.co"

    client_config {
      service {
        namespace = "elastic-system"
        name      = "elastic-webhook-server"
        path      = "/validate-agent-k8s-elastic-co-v1alpha1-agent"
      }

      ca_bundle = [10]
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Exact"
    side_effects              = "None"
    admission_review_versions = ["v1beta1"]
  }

  webhook {
    name = "elastic-apm-validation-v1.k8s.elastic.co"

    client_config {
      service {
        namespace = "elastic-system"
        name      = "elastic-webhook-server"
        path      = "/validate-apm-k8s-elastic-co-v1-apmserver"
      }

      ca_bundle = [10]
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Exact"
    side_effects              = "None"
    admission_review_versions = ["v1beta1"]
  }

  webhook {
    name = "elastic-apm-validation-v1beta1.k8s.elastic.co"

    client_config {
      service {
        namespace = "elastic-system"
        name      = "elastic-webhook-server"
        path      = "/validate-apm-k8s-elastic-co-v1beta1-apmserver"
      }

      ca_bundle = [10]
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Exact"
    side_effects              = "None"
    admission_review_versions = ["v1beta1"]
  }

  webhook {
    name = "elastic-beat-validation-v1beta1.k8s.elastic.co"

    client_config {
      service {
        namespace = "elastic-system"
        name      = "elastic-webhook-server"
        path      = "/validate-beat-k8s-elastic-co-v1beta1-beat"
      }

      ca_bundle = [10]
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Exact"
    side_effects              = "None"
    admission_review_versions = ["v1beta1"]
  }

  webhook {
    name = "elastic-ent-validation-v1.k8s.elastic.co"

    client_config {
      service {
        namespace = "elastic-system"
        name      = "elastic-webhook-server"
        path      = "/validate-enterprisesearch-k8s-elastic-co-v1-enterprisesearch"
      }

      ca_bundle = [10]
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Exact"
    side_effects              = "None"
    admission_review_versions = ["v1beta1"]
  }

  webhook {
    name = "elastic-ent-validation-v1beta1.k8s.elastic.co"

    client_config {
      service {
        namespace = "elastic-system"
        name      = "elastic-webhook-server"
        path      = "/validate-enterprisesearch-k8s-elastic-co-v1beta1-enterprisesearch"
      }

      ca_bundle = [10]
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Exact"
    side_effects              = "None"
    admission_review_versions = ["v1beta1"]
  }

  webhook {
    name = "elastic-es-validation-v1.k8s.elastic.co"

    client_config {
      service {
        namespace = "elastic-system"
        name      = "elastic-webhook-server"
        path      = "/validate-elasticsearch-k8s-elastic-co-v1-elasticsearch"
      }

      ca_bundle = [10]
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Exact"
    side_effects              = "None"
    admission_review_versions = ["v1beta1"]
  }

  webhook {
    name = "elastic-es-validation-v1beta1.k8s.elastic.co"

    client_config {
      service {
        namespace = "elastic-system"
        name      = "elastic-webhook-server"
        path      = "/validate-elasticsearch-k8s-elastic-co-v1beta1-elasticsearch"
      }

      ca_bundle = [10]
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Exact"
    side_effects              = "None"
    admission_review_versions = ["v1beta1"]
  }

  webhook {
    name = "elastic-kb-validation-v1.k8s.elastic.co"

    client_config {
      service {
        namespace = "elastic-system"
        name      = "elastic-webhook-server"
        path      = "/validate-kibana-k8s-elastic-co-v1-kibana"
      }

      ca_bundle = [10]
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Exact"
    side_effects              = "None"
    admission_review_versions = ["v1beta1"]
  }

  webhook {
    name = "elastic-kb-validation-v1beta1.k8s.elastic.co"

    client_config {
      service {
        namespace = "elastic-system"
        name      = "elastic-webhook-server"
        path      = "/validate-kibana-k8s-elastic-co-v1beta1-kibana"
      }

      ca_bundle = [10]
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Exact"
    side_effects              = "None"
    admission_review_versions = ["v1beta1"]
  }
}

