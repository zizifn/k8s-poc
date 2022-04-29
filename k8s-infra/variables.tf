variable "local" {
  type = bool
  description = "local"
  default = false
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key to use for connecting to the worker nodes"
  default = null
  sensitive = true
}

variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
  sensitive = true
}


# login variable
variable "tenancy_ocid" {
  type        = string
  description = "tenancy_ocid"
  sensitive   = true
}

variable "user_ocid" {
  type        = string
  description = "user_ocid"
  sensitive   = true
}

variable "private_key" {
  type        = string
  description = "private_key"
  sensitive   = true
}
variable "fingerprint" {
  type        = string
  description = "fingerprint"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "region"
}