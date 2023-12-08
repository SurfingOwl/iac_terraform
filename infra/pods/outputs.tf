output "backend_pod_name" {
  value = kubernetes_pod.babyteacher_backend.metadata.0.name
}