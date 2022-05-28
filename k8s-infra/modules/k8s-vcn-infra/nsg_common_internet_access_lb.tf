resource "oci_core_network_security_group" "nsg_common_internet_access_lb" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "nsg_common_internet_access_lb"
  freeform_tags = {"type"= "nsg"}
}

resource "oci_core_network_security_group_security_rule" "http_network_security_group_security_rule_lb" {
  #Required
  network_security_group_id = oci_core_network_security_group.nsg_common_internet_access.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp
  #Optional
  description = "port manipulate the Kubernetes cluster"
  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "https_network_security_group_security_rule_lb" {
  #Required
  network_security_group_id = oci_core_network_security_group.nsg_common_internet_access.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp
  #Optional
  description = "allow https"
  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}
