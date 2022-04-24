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

data "oci_core_vcn" "k8s_vcn" {
    #Required
    vcn_id = var.vcn_id
}

data "oci_core_subnets" "k8s_subnets" {
    #Required
    compartment_id = var.compartment_id

    #Optional
    vcn_id = var.vcn_id
}


output "test-demo11" {
  value = oci_core_subnets.k8s_subnets
}

