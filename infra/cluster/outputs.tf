output "cluster_host" {
  value = scaleway_k8s_cluster.this.kubeconfig[0].host
}
output "cluster_token" {
  value = scaleway_k8s_cluster.this.kubeconfig[0].token
}
output "cluster_ca_certificate" {
  value = scaleway_k8s_cluster.this.kubeconfig[0].cluster_ca_certificate
}
