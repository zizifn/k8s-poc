resource "oci_core_network_security_group" "nsg_private_internet_access" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "nsg_private_internet_access"
  freeform_tags = {"type"= "nsg"}
}
resource "oci_core_network_security_group_security_rule" "egress_oracle_network_security_group_security_rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.nsg_private_internet_access.id
  direction                 = "EGRESS"
  protocol                  = "all"
  #Optional
  description = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
  destination = "all-yny-services-in-oracle-services-network"
  destination_type = "SERVICE_CIDR_BLOCK"
  stateless   = false
}

resource "oci_core_network_security_group_security_rule" "egress_icmp_network_security_group_security_rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.nsg_private_internet_access.id
  direction                 = "EGRESS"
  protocol                  = "1" # icmp
  #Optional
  description = "icmp"
  destination      = "0.0.0.0/0"
  destination_type  = "CIDR_BLOCK"
  stateless   = false
  icmp_options  {
    type = 3
    code = 4
  }
}

# resource "oci_core_network_security_group_security_rule" "egress_all_network_security_group_security_rule" {
#   #Required
#   network_security_group_id = oci_core_network_security_group.nsg_private_internet_access.id
#   direction                 = "EGRESS"
#   protocol                  = "all" # icmp
#   #Optional
#   description = "all"
#   destination      = "0.0.0.0/0"
#   destination_type  = "CIDR_BLOCK"
#   stateless   = false
# }

# http 80
resource "oci_core_network_security_group_security_rule" "egress_80_network_security_group_security_rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.nsg_private_internet_access.id
  direction                 = "EGRESS"
  protocol                  = "6"
  #Optional
  description = "http 80"
  destination = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}
# http 443
resource "oci_core_network_security_group_security_rule" "egress_443_network_security_group_security_rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.nsg_private_internet_access.id
  direction                 = "EGRESS"
  protocol                  = "6"
  #Optional
  description = "http 443"
  destination = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

