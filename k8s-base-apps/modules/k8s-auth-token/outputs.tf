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

# output "kubeconfig_sa_secret" {
#     value = data.kubernetes_service_account_v1.kubeconfig_sa
#     # sensitive = true
# }

# use secret to get token
data "kubernetes_secret" "kubeconfig_sa_secret" {
  metadata {
    name = try(data.kubernetes_service_account_v1.kubeconfig_sa.default_secret_name, data.kubernetes_service_account_v1.kubeconfig_sa.secret[0].name)
  }
}


output "kubeconfig_sa_secret" {
    value = data.kubernetes_secret.kubeconfig_sa_secret
    # sensitive = true
}