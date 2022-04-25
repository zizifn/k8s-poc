# provider "kubernetes" {
#   config_path    = "~/.kube/config"
# }
resource "helm_release" "ingress-nginx" {
  name       = "my-ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.1.0"

  values = [
    "${file("${path.module}/values.yaml")}"
  ]

  set {
    name  = "controller.service.loadBalancerIP"
    value = var.ingrss_nginx_lb_ip
  }
}