resource "oci_core_network_security_group" "nsg_common_internet_access" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "nsg_common_internet_access"
  freeform_tags  = { "type" = "nsg" }
}
resource "oci_core_network_security_group_security_rule" "ssh_network_security_group_security_rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.nsg_common_internet_access.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp
  #Optional
  description = "ssh"
  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "ssh2_network_security_group_security_rule" {
  #Required
  network_security_group_id = oci_core_network_security_group.nsg_common_internet_access.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp
  #Optional
  description = "ssh2"
  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 1025
      min = 1025
    }
  }
}

resource "oci_core_network_security_group_security_rule" "k8s_api_network_security_group_security_rule" {
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
      max = 6443
      min = 6443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "http_network_security_group_security_rule" {
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

resource "oci_core_network_security_group_security_rule" "https_network_security_group_security_rule" {
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
      max = 443
      min = 443
    }
  }
}
