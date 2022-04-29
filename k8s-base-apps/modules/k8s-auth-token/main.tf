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
