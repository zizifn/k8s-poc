
output "internet_gateway_all_attributes" {
  value = module.vcn.internet_gateway_all_attributes
}
output "vcn_id" {
  value = module.vcn.vcn_id
}

output "k8s_vcn_api_public_subnet" {
  value = oci_core_subnet.k8s_vcn_api_public_subnet
}

output "k8s_vcn_api_private_subnet" {
  value = oci_core_subnet.k8s_vcn_api_private_subnet
}
output "k8s_vcn_lb_public_subnet" {
  value = oci_core_subnet.k8s_vcn_lb_public_subnet
}

output "k8s_vcn_lb_private_subnet" {
  value = oci_core_subnet.k8s_vcn_lb_private_subnet
}
output "k8s_vcn_node_public_subnet" {
  value = oci_core_subnet.k8s_vcn_node_public_subnet
}

output "k8s_vcn_node_private_subnet" {
  value = oci_core_subnet.k8s_vcn_node_private_subnet
}

output "nsg_common_internet_access_id" {
  value = oci_core_network_security_group.nsg_common_internet_access.id
}
output "nsg_private_internet_access" {
  value = oci_core_network_security_group.nsg_private_internet_access.id
}
data "oci_core_public_ips" "oci_core_public_ips" {
    #Required
    compartment_id = var.compartment_id
    scope = "REGION"
    lifetime = "RESERVED"
}

output "ingrss_nginx_lb_ip" {
  value = [for ip in data.oci_core_public_ips.oci_core_public_ips.public_ips : ip if ip.display_name =="k8s_lb"][0].ip_address
  sensitive = true
}
