
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
  description = "user_ocid"
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
  description = "region"
}