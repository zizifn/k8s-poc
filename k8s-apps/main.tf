
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
    local = {
      source = "hashicorp/local"
    }
  }
}


provider "kubernetes" {
  # config_path = "~/.kube/config"
  host                     = var.k8s_host
  config_context_auth_info = var.config_context_auth_info
  # username =
  token                  = var.service_account_token
  cluster_ca_certificate = try(base64decode(var.cluster_ca_certificate), null)
}

module "k8s-app-config-map" {
  source = "./k8s-app-config-map"
}

module "k8s-app-hello" {
  source = "./k8s-app-hello"
  depends_on = [
    module.k8s-app-config-map
  ]
}

# move history for state
moved {
  from = module.k8s-secrets.kubernetes_secret_v1.secret_ap123456
  to   =  module.k8s-app-hello.kubernetes_secret_v1.secret_ap123456
}
