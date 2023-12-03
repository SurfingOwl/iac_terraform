output "cluster_ip" {
  value = kubernetes_service.backend_service.spec[0].cluster_ip
}
