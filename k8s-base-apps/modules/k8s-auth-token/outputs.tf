# get kubeconfig-sa info
data "kubernetes_service_account_v1" "kubeconfig_sa" {
  metadata {
    name = "kubeconfig-sa"
    namespace = "kube-system"
  }
  depends_on = [
    kubernetes_cluster_role_binding_v1.kubeconfig-sa-role
  ]
}

# output "temp2" {
#     value = data.kubernetes_service_account_v1.kubeconfig_sa.default_secret_name
#     # sensitive = true
# }

# use secret to get token
data "kubernetes_secret" "kubeconfig_sa_secret" {
  metadata {
    name = data.kubernetes_service_account_v1.kubeconfig_sa.default_secret_name
    namespace = data.kubernetes_service_account_v1.kubeconfig_sa.metadata[0].namespace
  }
}


output "kubeconfig_sa_secret" {
    value = data.kubernetes_secret.kubeconfig_sa_secret
    sensitive = true
}