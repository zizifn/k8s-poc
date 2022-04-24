terraform {

  #terraform cloud
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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.1"
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

module "tags" {
  source         = "./modules/tags"
  compartment_id = var.compartment_ocid

}

module "k8s-vcn-infra" {
  source         = "./modules/k8s-vcn-infra"
  compartment_id = var.compartment_ocid
  region         = var.region
  depends_on = [
    module.tags
  ]
}

module "k8s-cluster" {
  source         = "./modules/k8s-cluster"
  compartment_id = var.compartment_ocid
  vcn_id         = module.k8s-vcn-infra.vcn_id
  is_arm         = false
  depends_on = [
    module.k8s-vcn-infra
  ]
}

module "k8s-ingress-nginx" {
  source             = "./modules/k8s-ingress-nginx"
  ingrss_nginx_lb_ip = var.ingrss_nginx_lb_ip
}

module "k8s-app-hello" {
  source = "./modules/k8s-app-hello"
}

output "echo" {
  value = 1
}

# move history
moved {
  from = module.k8s-ingress-nginx.helm_release.example
  to   = module.k8s-ingress-nginx.helm_release.ingress-nginx
}
