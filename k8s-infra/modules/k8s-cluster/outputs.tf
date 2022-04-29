output "id" {
  value = oci_containerengine_cluster.k8s_cluster.id
  sensitive = true
}