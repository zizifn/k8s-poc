resource "kubernetes_cluster_role" "otelcontribcol" {
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

