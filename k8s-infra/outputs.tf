output "ingrss_nginx_lb_ip" {
  value = module.k8s-vcn-infra.ingrss_nginx_lb_ip
  sensitive = true
}

output "nsg_common_internet_access_id" {
  value = module.k8s-vcn-infra.nsg_common_internet_access_id
  sensitive = true
}