resource "helm_release" "opentelemetry_operator" {
  name       = "my-opentelemetry-operator"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "open-telemetry/opentelemetry-operator"
  namespace  = "opentelemetry-operator-system"
}