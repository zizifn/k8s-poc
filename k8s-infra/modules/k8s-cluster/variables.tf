variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
  sensitive   = true
}

variable "vcn_id" {
  type        = string
  description = "vcn_id"
}

variable "k8s_vcn_api_public_subnet_id" {
  type        = string
  description = "k8s_vcn_api_public_subnet"
}
variable "k8s_vcn_lb_public_subnet_id" {
  type        = string
  description = "k8s_vcn_lb_public_subnet"
}

variable "k8s_vcn_node_public_subnet_id" {
  type        = string
  description = "k8s_vcn_node_public_subnet"
}

variable "k8s_vcn_node_private_subnet_id" {
  type        = string
  description = "k8s_vcn_node_private_subnet"
}

variable "is_arm" {
  type        = bool
  description = "arm"
  default     = true
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key to use for connecting to the worker nodes"
  default     = null
}

