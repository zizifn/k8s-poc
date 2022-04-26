resource "oci_core_network_security_group" "nsg_common_internet_access" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = module.vcn.vcn_id
    display_name = "nsg_common_internet_access"
}