resource "kubernetes_cluster_role_binding" "otelcontribcol" {
  metadata {
    name = "otelcontribcol"

    labels = {
      app = "otelcontribcol"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "otelcontribcol"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "otelcontribcol"
  }
}

