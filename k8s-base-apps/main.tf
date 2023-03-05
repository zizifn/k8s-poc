terraform {

  #terraform cloud
  cloud {
    # 用来同步 terraform state 到cloud 上。
    organization = "zizifn"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      name = "k8s-base-apps"
      # tags = ["networking", "source:cli"]
    }
  }

  required_providers {
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

locals {
  oci_config_path = "../oci_kube_config.temp"
}

provider "kubernetes" {
  config_path              = fileexists(local.oci_config_path) ? local.oci_config_path : null
  host                     = var.k8s_host
  config_context_auth_info = var.config_context_auth_info
  # username =
  token                  = var.service_account_token
  cluster_ca_certificate = try(base64decode(var.cluster_ca_certificate), null)
}

provider "helm" {
  kubernetes {
    config_path              = fileexists(local.oci_config_path) ? local.oci_config_path : null
    host                     = var.k8s_host
    config_context_auth_info = var.config_context_auth_info
    # username =
    token                  = var.service_account_token
    cluster_ca_certificate = try(base64decode(var.cluster_ca_certificate), null)
  }
  debug = true
}


module "k8s-auth-token" {
  source = "./modules/k8s-auth-token"
}


# get kubeconfig-sa secrets

resource "local_sensitive_file" "sa_kube_config" {
  count = var.local ? 1 : 0
  content = templatefile("${path.module}/sa_kube_config.tftpl",
    {
      host                     = ""
      config_context_auth_info = "kubeconfig-sa"
      token                    = module.k8s-auth-token.kubeconfig_sa_secret.data.token
      cluster_ca_certificate   = base64encode(module.k8s-auth-token.kubeconfig_sa_secret.data["ca.crt"])
  })
  filename = "../${path.module}/sa_kube_config.temp"
  depends_on = [
    module.k8s-auth-token
  ]
}
module "k8s-base-crds" {
  source = "./modules/k8s-base-crds"
}

module "k8s-cert-manager" {
  source = "./modules/k8s-cert-manager"
  depends_on = [
    module.k8s-base-crds
  ]
}

module "k8s-cert-issuer" {
  source               = "./modules/k8s-cert-issuer"
  cloudflare_api_token = var.cloudflare_api_token
  letsencrypt_email    = var.letsencrypt_email
  depends_on = [
    module.k8s-cert-manager
  ]
}

module "k8s-ingress-nginx" {
  source             = "./modules/k8s-ingress-nginx"
  lb_nsg_id          = var.nsg_common_internet_access_id
  ingrss_nginx_lb_ip = var.ingrss_nginx_lb_ip

  depends_on = [
    module.k8s-cert-issuer
  ]
}

# module "k8s-opentelemetry-operator" {
#   source = "./modules/k8s-opentelemetry-operator"
# }

module "k8s-opentelemetry-collector" {
  source = "./modules/k8s-opentelemetry-collector"
  depends_on = [
    module.k8s-auth-token
  ]
}


# 这里有点问题，就使用 kube 命令直接部署把。
# module "k8s-eck" {
#   source = "./modules/k8s-eck"
#   depends_on = [
#     module.k8s-auth-token,
#     module.k8s-eck-operator
#   ]
# }
