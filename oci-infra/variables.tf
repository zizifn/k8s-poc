variable "bucket_namespace" {
    default = "ax5fz1ydd95f"
}
variable "compartment_ocid" {
  type        = string
  description = "The compartment to create the resources in"
}



# login variable

variable "tenancy_ocid" {
  type        = string
  description = "tenancy_ocid"
}

variable "user_ocid" {
  type        = string
  description = "The compartment to create the resources in"
}

variable "private_key" {
  type        = string
  description = "private_key"
}
variable "fingerprint" {
  type        = string
  description = "fingerprint"
}

variable "region" {
  type        = string
  description = "The region to provision the resources in"
}