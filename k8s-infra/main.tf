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
      version = "~> 4.109.0"
    }
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = ">= 2.10.0"
    # }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }
  }


}
# cau be use this no need .oci/config
provider "oci" {
  auth         = "APIKey"
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  private_key  = try(base64decode(var.private_key), null)
  fingerprint  = var.fingerprint
  region       = var.region
}

module "tags" {
  source         = "./modules/tags"
  compartment_id = var.compartment_id
}

module "k8s-vcn-infra" {
  source         = "./modules/k8s-vcn-infra"
  compartment_id = var.compartment_id
  region         = var.region
  depends_on = [
    module.tags
  ]
}

module "k8s-cluster" {
  source                         = "./modules/k8s-cluster"
  compartment_id                 = var.compartment_id
  vcn_id                         = module.k8s-vcn-infra.vcn_id
  is_arm                         = true
  ssh_public_key                 = var.ssh_public_key
  k8s_vcn_api_public_subnet_id   = module.k8s-vcn-infra.k8s_vcn_api_public_subnet.id
  k8s_vcn_lb_public_subnet_id    = module.k8s-vcn-infra.k8s_vcn_lb_public_subnet.id
  k8s_vcn_node_public_subnet_id  = module.k8s-vcn-infra.k8s_vcn_node_public_subnet.id
  k8s_vcn_node_private_subnet_id = module.k8s-vcn-infra.k8s_vcn_node_private_subnet.id
  depends_on = [
    module.k8s-vcn-infra
  ]
}

resource "local_sensitive_file" "ingrss_nginx_lb_ip" {
  count    = var.local ? 1 : 0
  content  = "${module.k8s-vcn-infra.ingrss_nginx_lb_ip}\n ${module.k8s-vcn-infra.nsg_common_internet_access_id}"
  filename = "../${path.module}/ingrss_nginx_lb_ip.temp"
}

locals {
  cluster_id = module.k8s-cluster.id
  test       = pathexpand("~/${path.module}/main.tf")
  command_map = sensitive(substr(local.test, 0, 1) == "/" ? {
    command = "oci ce cluster create-kubeconfig --cluster-id ${local.cluster_id} --file ../oci_kube_config.temp --token-version 2.0.0  --kube-endpoint PUBLIC_ENDPOINT",
    # command = "ls -al && pwd"
    intrepreter = null
    } : {
    command     = "oci ce cluster create-kubeconfig --cluster-id ${local.cluster_id} --file ../oci_kube_config.temp --region ap-chuncheon-1 --token-version 2.0.0  --kube-endpoint PUBLIC_ENDPOINT"
    intrepreter = "powershell"
  })
}


resource "null_resource" "setup_kube_config_from_oci" {
  provisioner "local-exec" {
    command     = local.command_map.command
    interpreter = local.command_map.intrepreter != null ? [local.command_map.intrepreter] : null
  }
  triggers = {
    always_run = timestamp()
  }
}


module "k8s-echo-test" {
  source         = "./modules/k8s-echo-test"
  compartment_id = var.compartment_id
  depends_on = [
    module.k8s-cluster
  ]
}

# move history for state
# moved {
#   from = module.k8s-ingress-nginx.helm_release.example
#   to   = module.k8s-ingress-nginx.helm_release.ingress-nginx
# }

# moved {
#   from = module.k8s-secrets
#   to   = module.k8s-apps.module.k8s-secrets
# }
# moved {
#   from = module.k8s-app-config-map
#   to   = module.k8s-apps.module.k8s-app-config-map
# }

# moved {
#   from = module.k8s-app-hello
#   to   = module.k8s-apps.module.k8s-app-hello
# }

