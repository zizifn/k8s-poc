
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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.10.0"
    }
  }
}


provider "kubernetes" {
  # config_path = "~/.kube/config"
  host = var.k8s_host
  config_context_auth_info = var.config_context_auth_info
  # username =
  token = var.service_account_token
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate_base64)
}

module "k8s-secrets" {
  source = "./k8s-secrets"
  depends_on = [
    module.file
  ]
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