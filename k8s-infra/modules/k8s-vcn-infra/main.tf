# create VCN
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.72.0"
    }
  }
}

module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.4.0"

  compartment_id = var.compartment_id
  region         = var.region

  internet_gateway_route_rules = null
  local_peering_gateways       = null
  nat_gateway_route_rules      = null

  vcn_name      = "k8s-vcn"
  vcn_dns_label = "k8svcn"
  vcn_cidrs     = ["10.0.0.0/16"]

  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true
}

resource "oci_core_security_list" "private_k8s_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id

  display_name = "k8s-private-subnet-sl"

  # allow traffic coming with VCN,可以更具体点，分成 worker和Kubernetes，这里为了简化，在VCN 里面允许相互连接。
  egress_security_rules {
    stateless        = false
    destination      = "10.0.0.0/16"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # allow traffic coming with VCN,可以更具体点，分成 worker和Kubernetes，这里为了简化，在VCN 里面允许相互连接。
  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }
}

resource "oci_core_security_list" "public_k8s_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id

  display_name = "k8s-public-subnet-sl"

  # allow out to any ips, maybe not needed.
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }
  # allow traffic within VCN, can scope to subnet
  egress_security_rules {
    stateless        = false
    destination      = "10.0.0.0/16"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }
  # allow traffic coming from VCNs, can scope to subnet
  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # enable icmp
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
  }
}

resource "oci_core_route_table" "k8s_private_subnet_route_table" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id

  #Optional
  defined_tags = { "k8s-operations.Cost" = "k8s" }
  display_name = "k8s_private_subnet_route_table"
  # freeform_tags = {"Department"= "Finance"}
  route_rules {
    destination       = "all-yny-services-in-oracle-services-network"
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = module.vcn.service_gateway_id
    description       = "traffic to OCI services"
  }
  route_rules {
    #Required
    network_entity_id = module.vcn.nat_gateway_id

    #Optional
    description      = "traffic to/from internet"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }

}

resource "oci_core_route_table" "k8s_public_subnet_route_table" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id

  #Optional
  defined_tags = { "k8s-operations.Cost" = "k8s" }
  display_name = "k8s_public_subnet_route_table"
  # freeform_tags = {"Department"= "Finance"}
  route_rules {
    #Required
    network_entity_id = module.vcn.internet_gateway_id

    #Optional
    description      = "traffic to/from internet"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }

}

# for k8s api
resource "oci_core_subnet" "k8s_vcn_api_public_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.0.0/24"

  route_table_id    = oci_core_route_table.k8s_public_subnet_route_table.id
  security_list_ids = [oci_core_security_list.public_k8s_subnet_sl.id]
  display_name      = "k8s-api-public-subnet"
  dns_label         = "apipublic"
}

resource "oci_core_subnet" "k8s_vcn_api_private_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.2.0/24"

  route_table_id            = oci_core_route_table.k8s_private_subnet_route_table.id
  security_list_ids         = [oci_core_security_list.private_k8s_subnet_sl.id]
  display_name              = "k8s-api-private-subnet"
  dns_label                 = "apiprivate"
  prohibit_internet_ingress = true
}

resource "oci_core_subnet" "k8s_vcn_lb_public_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.4.0/24"

  route_table_id    = oci_core_route_table.k8s_public_subnet_route_table.id
  security_list_ids = [oci_core_security_list.public_k8s_subnet_sl.id]
  display_name      = "k8s-lb-public-subnet"
  dns_label         = "lbpublic"
}

resource "oci_core_subnet" "k8s_vcn_lb_private_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.6.0/24"

  route_table_id            = oci_core_route_table.k8s_private_subnet_route_table.id
  security_list_ids         = [oci_core_security_list.private_k8s_subnet_sl.id]
  display_name              = "k8s-lb-private-subnet"
  dns_label                 = "lbprivate"
  prohibit_internet_ingress = true
}

resource "oci_core_subnet" "k8s_vcn_node_public_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.8.0/24"

  route_table_id    = oci_core_route_table.k8s_public_subnet_route_table.id
  security_list_ids = [oci_core_security_list.public_k8s_subnet_sl.id]
  display_name      = "k8s-node-public-subnet"
  dns_label         = "nodepublic"
}
resource "oci_core_subnet" "k8s_vcn_node_private_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.10.0/24"

  route_table_id            = oci_core_route_table.k8s_private_subnet_route_table.id
  security_list_ids         = [oci_core_security_list.private_k8s_subnet_sl.id]
  display_name              = "k8s-node-private-subnet"
  dns_label                 = "nodeprivate"
  prohibit_internet_ingress = true
}
