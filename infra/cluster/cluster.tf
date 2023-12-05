terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.29.0"
    }
  }
}

resource "null_resource" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.this]
  triggers   = {
    host                   = scaleway_k8s_cluster.this.kubeconfig[0].host
    token                  = scaleway_k8s_cluster.this.kubeconfig[0].token
    cluster_ca_certificate = scaleway_k8s_cluster.this.kubeconfig[0].cluster_ca_certificate
  }
}

resource "scaleway_k8s_cluster" "this" {
  cni                         = "cilium"
  name                        = "babyteacher-cluster"
  version                     = "1.24.3"
  delete_additional_resources = true
  private_network_id          = var.private_network_id
}

resource "scaleway_k8s_pool" "this" {
  cluster_id = scaleway_k8s_cluster.this.id
  name       = "babyteacher-pool"
  node_type  = "DEV1-M"
  size       = 1
}

