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
  set {
    name  = "controller.service.annotations.oci\\.oraclecloud\\.com/oci-network-security-groups" # 转移 逗号
    value = var.lb_nsg_id
  }
}