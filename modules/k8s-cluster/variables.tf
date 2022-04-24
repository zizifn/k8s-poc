variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
  sensitive   = true
}

variable "vcn_id" {
  type        = string
  description = "vcn_id"
}

variable "is_arm" {
  type        = bool
  description = "arm"
  default = true
}

