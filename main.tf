terraform {

  cloud {
    organization = "zizifn"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      name = "oci-poc"
      # tags = ["networking", "source:cli"]
    }
  }

  required_providers {
    oci = {
      source  = "hashicorp/oci"
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

module "oci-infra" {
  source           = "./modules/oci-infra"
  compartment_ocid = var.compartment_ocid

  # tags = {
  #   Terraform   = "true"
  #   Environment = "dev"
  # }
}

