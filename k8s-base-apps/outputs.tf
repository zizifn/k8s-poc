# output "aarch64" {
#   // .*aarch64.*
#     value = [for image in data.oci_core_images.test_images.images : image if length(regexall("(?i).*aarch64.*", image.display_name)) > 0]
# }
# output "amd" {
#   // .*aarch64.*
#     value = [for image in data.oci_core_images.test_images.images : image if length(regexall("(?i).*aarch64|GPU.*", image.display_name)) < 1]
# }


output "temp" {
    value = module.k8s-auth-token.kubeconfig_sa_secret
    sensitive = true
}