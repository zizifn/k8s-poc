# cau be use this no need .oci/config
provider "oci" {
    tenancy_ocid = var.tenancy_ocid
    user_ocid = var.user_ocid
    private_key = var.private_key
    fingerprint = var.fingerprint
    region = var.region
}

data "oci_objectstorage_namespace" "bucket_namespace" {
    compartment_id = var.compartment_ocid
}

resource "oci_objectstorage_bucket" "create_bucket" {
    # required
    compartment_id = var.compartment_ocid
    name = "my_new_bucket"
    namespace =  data.oci_objectstorage_namespace.bucket_namespace.namespace

    # optional
    access_type = "NoPublicAccess"
}

output "bucket_namespace" {
    value = data.oci_objectstorage_namespace.bucket_namespace.namespace
}

output "new_bucket" {
    value = oci_objectstorage_bucket.create_bucket
}


# data "oci_objectstorage_bucket_summaries" "bucket_summaries" {
#     compartment_id = var.compartment_ocid
#     namespace = var.bucket_namespace
# }

# output "bucket_summaries" {
#     value = data.oci_objectstorage_bucket_summaries.bucket_summaries
# }