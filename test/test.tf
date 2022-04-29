terraform {

  cloud {
    # 用来同步 terraform state 到cloud 上。
    organization = "zizifn"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      name = "test-demo"
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
      version = "2.10.0"
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

data "oci_containerengine_clusters" "test_clusters" {
    #Required
    compartment_id = var.compartment_id

    #Optional
    name = "k8s-cluster"
}

data "oci_containerengine_cluster_option" "test_cluster_option" {
    #Required
    cluster_option_id = data.oci_containerengine_clusters.test_clusters.clusters[0].id

    #Optional
    compartment_id = var.compartment_id
}

# resource "local_file" "kube_config" {
#   content_base64  = var.kube_config_base64
#   filename = "${path.root}/kube_config"
# }

provider "kubernetes" {
  # config_path = "~/.kube/config"
  host = "https://146.56.118.29:6443"
  config_context_auth_info = "kubeconfig-sa"
  # username =
  token = "***REMOVED***"
  cluster_ca_certificate = base64decode("***REMOVED***==")
}

resource "local_sensitive_file" "foo" {
    content  = "foo!"
    filename = "../${path.root}/foo.bar"
}
resource "local_sensitive_file" "sa_kube_config" {
    content  = templatefile("${path.module}/sa_kube_config.tftpl",
    {
      host = "test"
      config_context_auth_info = "test"
      token = "test"
      cluster_ca_certificate = "test"
    })
    filename = "${path.module}/sa_kube_config"
}

data "kubernetes_pod_v1" "test" {
  metadata {
    name = "my-ingress-nginx-admission-create--1-vj9zz"
  }
}
# data "oci_core_vcn" "k8s_vcn" {
#     #Required
#     vcn_id = var.vcn_id
# }

# data "oci_core_network_security_groups" "internet_access_network_security_groups" {

#   #Optional
#   compartment_id = var.compartment_ocid
#   display_name   = "nsg_common_internet_access"
# }

# data "oci_core_public_ips" "oci_core_public_ips" {
#     #Required
#     compartment_id = var.compartment_ocid
#     scope = "REGION"
#     lifetime = "RESERVED"
# }

# locals {
#   test = [for ip in data.oci_core_public_ips.oci_core_public_ips.public_ips : ip if ip.display_name =="k8s_lb"][0].ip_address
# }
# output "test-demo11" {
#   value = local.test
# }



# data "oci_core_network_security_groups" "nsg_private_internet_access" {

#   #Optional
#   compartment_id = var.compartment_ocid
#   display_name   = "nsg_private_internet_access"
# }
# output "test-nsgs" {
#   value = data.oci_core_network_security_groups.nsg_private_internet_access.network_security_groups[*].id
# }

# output "kubernetes_namespace11" {
#   value     = data.kubernetes_pod_v1.test
#   sensitive = true
# }

# output "k8s" {
#   value     = data.oci_containerengine_clusters.test_clusters
#   # sensitive = true
# }

output "testjson" {
  value = jsondecode(file("${path.module}/sa_kube_config")).cluster_ca_certificate
}

