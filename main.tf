terraform {

  cloud {
    # 用来同步 terraform state 到cloud 上。
    organization = "zizifn"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      name = "oci-poc"
      # tags = ["networking", "source:cli"]
    }
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.72.0"
    }
  }
}
# cau be use this no need .oci/config
provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  private_key  = var.private_key
  fingerprint  = var.fingerprint
  region       = var.region
}
# module "tags" {
#   source           = "./modules/tags"
#   compartment_id = var.compartment_ocid
# }

module "k8s-vcn-infra" {
  source           = "./modules/k8s-vcn-infra"
  compartment_id = var.compartment_ocid
  region           = var.region
}

module "k8s-cluster" {
  source           = "./modules/k8s-cluster"
  compartment_id = var.compartment_ocid
  vcn_id= module.k8s-vcn-infra.vcn_id
}


# data "oci_core_service_gateways" "test_service_gateways" {
#     #Required
#     compartment_id = var.compartment_ocid

# }
# data "oci_identity_availability_domains" "ads" {
#   compartment_id = var.compartment_ocid
# }

# output "nat_route_id" {
#     value = data.oci_core_service_gateways.test_service_gateways
# }


moved {
  from = module.k8s-vcn2-infra
  to   = module.k8s-vcn-infra
}
