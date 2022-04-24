terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.72.0"
    }
  }
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
data "oci_core_images" "test_images" {
  #Required
  compartment_id = var.compartment_id

  operating_system         = "Oracle Linux"
  operating_system_version = "8"
}

locals {
  kubernetes_version = "v1.22.5"
  vcn_public_subnet  = [for subnet in data.oci_core_subnets.k8s_subnets.subnets : subnet if length(regexall(".*public.*", subnet.display_name)) > 0]
  vcn_private_subnet = [for subnet in data.oci_core_subnets.k8s_subnets.subnets : subnet if length(regexall(".*private.*", subnet.display_name)) > 0]
  os = var.is_arm ? {
    image : [for image in data.oci_core_images.test_images.images : image if length(regexall("(?i).*aarch64.*", image.display_name)) > 0],
    shape : "VM.Standard.E3.Flex"
    } : {
    image : [for image in data.oci_core_images.test_images.images : image if length(regexall("(?i).*aarch64|GPU.*", image.display_name)) < 1]
    shape : "VM.Standard.E3.Flex"
  }
}

output "test" {
  value = local.vcn_public_subnet
}


resource "oci_containerengine_cluster" "k8s_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = local.kubernetes_version
  name               = "k8s-cluster"
  vcn_id             = var.vcn_id

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = local.vcn_public_subnet[0].id
  }

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = true
      is_tiller_enabled               = false
    }
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
    service_lb_config {
      freeform_tags = { "services" : "k8s-lb" }
    }
    service_lb_subnet_ids = local.vcn_public_subnet[*].id
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_containerengine_node_pool" "k8s_node_pool" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = local.kubernetes_version
  name               = "k8s-node-pool"
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = local.vcn_private_subnet[0].id
    }
    # placement_configs {
    #   availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    #   subnet_id           = local.vcn_private_subnet[0].id
    # }
    size = 2
    # defined_tags = { "operation.Cost" = "k8s" }
  }
  node_shape = local.os.shape

  node_shape_config {
    memory_in_gbs = 16
    ocpus         = 1
  }

  node_source_details {
    image_id    = local.os.image[0].id
    source_type = "image"
  }

  initial_node_labels {
    key   = "name"
    value = "k8s-cluster"
  }

  # ssh_public_key = var.ssh_public_key
}
