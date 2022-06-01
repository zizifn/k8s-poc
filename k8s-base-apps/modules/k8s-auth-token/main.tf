# terraform {
#   required_providers {
#     oci = {
#       source  = "oracle/oci"
#       version = "~> 4.72.0"
#     }
#   }
# }

resource "kubernetes_service_account_v1" "kubeconfig_sa" {
  metadata {
    name      = "kubeconfig-sa"
    namespace = "kube-system"
  }
}

resource "kubernetes_service_account_v1" "otelcontribcol_sa" {
  metadata {
    name = "otelcontribcol-sa"
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

resource "kubernetes_cluster_role_binding_v1" "kubeconfig-sa-role" {
  metadata {
    name = "add-kubeconfig-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  # subject {
  #   kind      = "Group"
  #   name      = "system:masters"
  #   api_group = "rbac.authorization.k8s.io"
  # }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.kubeconfig_sa.metadata[0].name
    namespace = kubernetes_service_account_v1.kubeconfig_sa.metadata[0].namespace
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



