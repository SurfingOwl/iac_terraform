output "cluster_host" {
  value = null_resource.kubeconfig.triggers.host
}
output "cluster_token" {
  value = null_resource.kubeconfig.triggers.token
}
output "cluster_ca_certificate" {
  value = null_resource.kubeconfig.triggers.cluster_ca_certificate
}
