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
data "oci_core_network_security_groups" "internet_access_network_security_groups_temp" {

  #Optional
  compartment_id = var.compartment_id
  display_name   = "nsg_common_internet_access2"
}

data "oci_core_network_security_groups" "internet_access_network_security_groups" {

  #Optional
  compartment_id = var.compartment_id
  display_name   = "nsg_common_internet_access"
}
data "oci_core_network_security_groups" "nsg_private_internet_access" {

  #Optional
  compartment_id = var.compartment_id
  display_name   = "nsg_private_internet_access"
}
data "oci_core_subnets" "k8s_subnets" {
  #Required
  compartment_id = var.compartment_id

  #Optional
  vcn_id = var.vcn_id
}
data "oci_core_images" "linux_os_images" {
  #Required
  compartment_id = var.compartment_id

  operating_system         = "Oracle Linux"
  operating_system_version = "8"
}

locals {
  kubernetes_version = "v1.22.5"
  # vcn_public_subnet  = [for subnet in data.oci_core_subnets.k8s_subnets.subnets : subnet if length(regexall(".*public.*", subnet.display_name)) > 0]
  # vcn_private_subnet = [for subnet in data.oci_core_subnets.k8s_subnets.subnets : subnet if length(regexall(".*private.*", subnet.display_name)) > 0]
  os = var.is_arm ? {
    image : [for image in data.oci_core_images.linux_os_images.images : image if length(regexall("(?i).*aarch64.*", image.display_name)) > 0],
    shape : "VM.Standard.A1.Flex"
    memory_in_gbs : 6
    ocpus : 1
    } : {
    image : [for image in data.oci_core_images.linux_os_images.images : image if length(regexall("(?i).*aarch64|GPU.*", image.display_name)) < 1]
    shape : "VM.Standard.E3.Flex"
    memory_in_gbs : 16
    ocpus : 1
  }
}


resource "oci_containerengine_cluster" "k8s_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = local.kubernetes_version
  name               = "k8s-cluster"
  vcn_id             = var.vcn_id

  endpoint_config {
    is_public_ip_enabled = true
    # https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfig.htm#subnetconfig
    subnet_id = var.k8s_vcn_api_public_subnet_id
    nsg_ids   = data.oci_core_network_security_groups.internet_access_network_security_groups_temp.network_security_groups[*].id
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
    service_lb_subnet_ids = [var.k8s_vcn_lb_public_subnet_id]
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_containerengine_node_pool" "k8s_node_pool_private" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = local.kubernetes_version
  name               = "k8s-node-pool-private"
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.k8s_vcn_node_private_subnet_id
    }
    # placement_configs {
    #   availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    #   subnet_id           = local.vcn_private_subnet[0].id
    # }
    size = 2
    # defined_tags = { "operation.Cost" = "k8s" }
    freeform_tags = { "NodePool" = "k8s-node-pool-private" }
    nsg_ids = data.oci_core_network_security_groups.nsg_private_internet_access.network_security_groups[*].id
  }
  node_shape = local.os.shape

  node_shape_config {
    memory_in_gbs = local.os.memory_in_gbs
    ocpus         = local.os.ocpus
  }

  node_source_details {
    image_id    = local.os.image[0].id
    source_type = "image"
  }

  initial_node_labels {
    key   = "name"
    value = "k8s-node-private"
  }

  ssh_public_key = var.ssh_public_key
}

resource "oci_containerengine_node_pool" "k8s_node_pool_public" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = local.kubernetes_version
  name               = "k8s-node-pool-public"
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.k8s_vcn_node_public_subnet_id
    }
    size = 1
    # defined_tags = { "operation.Cost" = "k8s" }
    freeform_tags = { "NodePool" = "k8s-node-pool-public" }
    nsg_ids       = data.oci_core_network_security_groups.internet_access_network_security_groups.network_security_groups[*].id
  }
  node_shape = local.os.shape

  node_shape_config {
    memory_in_gbs = local.os.memory_in_gbs
    ocpus         = local.os.ocpus
  }

  node_source_details {
    image_id    = local.os.image[0].id
    source_type = "image"
  }

  initial_node_labels {
    key   = "name"
    value = "k8s-node-public"
  }

  ssh_public_key = var.ssh_public_key
}
