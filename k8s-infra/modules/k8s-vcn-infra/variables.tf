variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "The region to provision the resources in"
}

# variable "user_information" {
#   type = object({
#     name    = string
#     address = string
#   })
#   sensitive = true
# }