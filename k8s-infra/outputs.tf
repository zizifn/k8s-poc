output "ingrss_nginx_lb_ip" {
  value = module.k8s-vcn-infra.ingrss_nginx_lb_ip
  sensitive = true
}
