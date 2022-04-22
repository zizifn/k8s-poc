output "bucket_namespace" {
    value = data.oci_objectstorage_namespace.bucket_namespace.namespace
}

output "new_bucket" {
    value = oci_objectstorage_bucket.test_bucket
}