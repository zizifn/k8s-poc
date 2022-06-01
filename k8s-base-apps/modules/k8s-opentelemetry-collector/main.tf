resource "kubernetes_manifest" "opentelemetrycollector_otelcontribcol" {
  manifest = {
    "apiVersion" = "opentelemetry.io/v1alpha1"
    "kind" = "OpenTelemetryCollector"
    "metadata" = {
      "name" = "otelcontribcol"
      "namespace" = "default"
    }
    "spec" = {
      "config" = <<-EOT
      receivers:
        otlp:
          protocols:
            grpc:
            http:
          k8s_cluster:
            collection_interval: 10s
      processors:

      exporters:
        logging:

      service:
        pipelines:
          traces:
            receivers: [otlp, k8s_cluster]
            processors: []
            exporters: [logging]

      EOT
      "serviceAccount" = "otelcontribcol-sa"
    }
  }
}
