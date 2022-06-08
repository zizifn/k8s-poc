# resource "kubernetes_manifest" "elasticsearch_elasticsearch" {
#   manifest = {
#     "apiVersion" = "elasticsearch.k8s.elastic.co/v1"
#     "kind" = "Elasticsearch"
#     "metadata" = {
#       "name" = "elasticsearch"
#       "namespace" = "default"
#     }
#     "spec" = {
#       "nodeSets" = [
#         {
#           "config" = {
#             "node.store.allow_mmap" = false
#           }
#           "count" = 1
#           "name" = "default"
#           "volumeClaimTemplates" = [
#             {
#               "metadata" = {
#                 "name" = "elasticsearch-data"
#               }
#               "spec" = {
#                 "accessModes" = [
#                   "ReadWriteOnce",
#                 ]
#                 "resources" = {
#                   "requests" = {
#                     "storage" = "50Gi"
#                   }
#                 }
#                 "storageClassName" = "oci-bv"
#               }
#             },
#           ]
#         },
#       ]
#       "version" = "8.2.2"
#       "volumeClaimDeletePolicy" = "DeleteOnScaledownOnly"
#     }
#   }
# }

# resource "kubernetes_manifest" "kibana_kibana" {
#   manifest = {
#     "apiVersion" = "kibana.k8s.elastic.co/v1"
#     "kind" = "Kibana"
#     "metadata" = {
#       "name" = "kibana"
#       "namespace" = "default"
#     }
#     "spec" = {
#       "count" = 1
#       "elasticsearchRef" = {
#         "name" = "elasticsearch"
#       }
#       "http" = {
#         "tls" = {
#           "selfSignedCertificate" = {
#             "disabled" = true
#           }
#         }
#       }
#       "podTemplate" = {
#         "spec" = {
#           "containers" = [
#             {
#               "name" = "kibana"
#               "resources" = {
#                 "limits" = {
#                   "cpu" = "1"
#                   "memory" = "1Gi"
#                 }
#               }
#             },
#           ]
#         }
#       }
#       "version" = "8.2.2"
#     }
#   }

#   computed_fields = [ "spec.podTemplate.metadata.creationTimestamp" ]
# }

# resource "kubernetes_manifest" "ingress_kibana_ingress" {
#   manifest = {
#     "apiVersion" = "networking.k8s.io/v1"
#     "kind" = "Ingress"
#     "metadata" = {
#       "name" = "kibana-ingress"
#       "namespace" = "default"
#     }
#     "spec" = {
#       "ingressClassName" = "nginx"
#       "rules" = [
#         {
#           "host" = "k8s-kibana.zizi.press"
#           "http" = {
#             "paths" = [
#               {
#                 "backend" = {
#                   "service" = {
#                     "name" = "kibana-kb-http"
#                     "port" = {
#                       "number" = 5601
#                     }
#                   }
#                 }
#                 "path" = "/"
#                 "pathType" = "Prefix"
#               },
#             ]
#           }
#         },
#       ]
#       "tls" = [
#         {
#           "hosts" = [
#             "k8s-kibana.zizi.press",
#           ]
#           "secretName" = "zizi-press-tls"
#         },
#       ]
#     }
#   }
# }
