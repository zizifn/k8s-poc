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
      test1 = 333444 # can use hcl syntax
    }) # eyJ0ZXN0MSI6MzMzfQ==
  }
  # immutable = true  如果设置了这个，需要整个deploment 删除，然后重新创建
  type = "Opaque"
}
