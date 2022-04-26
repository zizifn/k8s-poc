
terraform {

  #terraform cloud
  cloud {
    # 用来同步 terraform state 到cloud 上。
    organization = "zizifn"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      name = "oci-k8s-apps"
      # tags = ["networking", "source:cli"]
    }
  }

  required_providers {
    # oci = {
    #   source  = "oracle/oci"
    #   version = "~> 4.72.0"
    # }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }

    # helm = {
    #   source  = "hashicorp/helm"
    #   version = ">= 2.5.1"
    # }
  }
}
# # cau be use this no need .oci/config
  # provider "oci" {
  #   tenancy_ocid = var.tenancy_ocid
  #   user_ocid    = var.user_ocid
  #   private_key  = var.private_key
  #   fingerprint  = var.fingerprint
  #   region       = var.region
  # }

# provider "helm" {
#   kubernetes {
#     config_path    = "~/.kube/config"
#   }
# }

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

module "k8s-secrets" {
  source = "./k8s-secrets"
}

module "k8s-app-config-map" {
  source = "./k8s-app-config-map"
}

module "k8s-app-hello" {
  source = "./k8s-app-hello"
  depends_on = [
    module.k8s-secrets,
    module.k8s-app-config-map
  ]
}