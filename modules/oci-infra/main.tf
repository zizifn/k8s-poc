data "oci_objectstorage_namespace" "bucket_namespace" {
    compartment_id = var.compartment_ocid
}

resource "oci_objectstorage_bucket" "test_bucket" {
    # required
    compartment_id = var.compartment_ocid
    name = "my_new_bucket"
    namespace =  data.oci_objectstorage_namespace.bucket_namespace.namespace

    # optional
    access_type = "NoPublicAccess"
}



