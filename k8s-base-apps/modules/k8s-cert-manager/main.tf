resource "kubernetes_namespace_v1" "cert_manager_namsespace" {
  metadata {
    annotations = {
      name = "cert-manager-annotation"
    }
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  name       = "my-cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace_v1.cert_manager_namsespace.metadata[0].name
  version    = "v1.8.0"
  depends_on = [
    kubernetes_namespace_v1.cert_manager_namsespace
  ]
}


