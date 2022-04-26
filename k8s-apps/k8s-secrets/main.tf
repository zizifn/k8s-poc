# terraform {
#   required_providers {
#     oci = {
#       source  = "oracle/oci"
#       version = "~> 4.72.0"
#     }
#   }
# }

resource "kubernetes_secret_v1" "secret_ap123456" {
  metadata {
    name = "ap123456"
  }

  data = {
    testvar = "test111"
    testfile     = "${file("${path.module}/data/test.txt")}"
    testjson = jsonencode({
      test1 = 333 # can use hcl syntax
    }) # eyJ0ZXN0MSI6MzMzfQ==
  }
  immutable = true
  type = "Opaque"
}
