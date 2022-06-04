resource "kubernetes_manifest" "elasticsearch_elasticsearch" {
  manifest = {
    "apiVersion" = "elasticsearch.k8s.elastic.co/v1"
    "kind" = "Elasticsearch"
    "metadata" = {
      "name" = "elasticsearch"
    }
    "spec" = {
      "nodeSets" = [
        {
          "config" = {
            "node.store.allow_mmap" = false
          }
          "count" = 1
          "name" = "default"
          "volumeClaimTemplates" = [
            {
              "metadata" = {
                "name" = "elasticsearch-data"
              }
              "spec" = {
                "accessModes" = [
                  "ReadWriteOnce",
                ]
                "resources" = {
                  "requests" = {
                    "storage" = "50Gi"
                  }
                }
                "storageClassName" = "oci-bv"
              }
            },
          ]
        },
      ]
      "version" = "8.2.2"
      "volumeClaimDeletePolicy" = "DeleteOnScaledownOnly"
    }
  }
}

resource "kubernetes_manifest" "kibana_kibana" {
  manifest = {
    "apiVersion" = "kibana.k8s.elastic.co/v1"
    "kind" = "Kibana"
    "metadata" = {
      "name" = "kibana"
    }
    "spec" = {
      "count" = 1
      "elasticsearchRef" = {
        "name" = "elasticsearch"
      }
      "podTemplate" = {
        "metadata" = {
          "labels" = {
            "foo" = "bar"
          }
        }
        "spec" = {
          "containers" = [
            {
              "name" = "kibana"
              "resources" = {
                "limits" = {
                  "cpu" = 1
                  "memory" = "1Gi"
                }
              }
            },
          ]
        }
      }
      "version" = "8.2.2"
    }
  }
}
