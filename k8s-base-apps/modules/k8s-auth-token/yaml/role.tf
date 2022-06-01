resource "kubernetes_service_account" "otelcontribcol" {
  metadata {
    name = "otelcontribcol"

    labels = {
      app = "otelcontribcol"
    }
  }
}

