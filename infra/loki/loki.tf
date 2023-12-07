resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-stack"
  namespace        = "loki"
  version          = "2.9.11"
  create_namespace = true

  set {
    name  = "grafana.enabled"
    value = "true"
  }
}