output "internet_gateway_all_attributes" {
  value = module.vcn.internet_gateway_all_attributes
}
output "vcn_id" {
  value = module.vcn.vcn_id
}

output "nsg_common_internet_access_id" {
  value = oci_core_network_security_group.nsg_common_internet_access.id
}