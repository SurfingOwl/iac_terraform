terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.29.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.24.0"
    }
  }

  backend "s3" {
    key       = "tf.tfstate"
    bucket    = "babyteacher-bucket"
    endpoints = { s3 = "https://s3.fr-par.scw.cloud" }
    region    = "fr-par"

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}

resource "scaleway_k8s_cluster" "this" {
  cni                         = "cilium"
  name                        = "babyteacher-cluster"
  version                     = "1.24.3"
  delete_additional_resources = true
}

resource "scaleway_k8s_pool" "this" {
  cluster_id = scaleway_k8s_cluster.this.id
  name       = "babyteacher-pool"
  node_type  = "DEV1-M"
  size       = 1
}

resource "local_file" "kubeconfig" {
  filename        = "${path.module}/kubeconfig"
  file_permission = "0600"
  content         = "scaleway_k8s_cluster.this.kubeconfig[0].config_file"
}

resource "kubernetes_pod" "babyteacher_pod" {
  metadata {
    name   = "babyteacher-pod"
    labels = {
      app = "babyteacher-pod"
    }
  }
  spec {
    container {
      name  = "backend"
      image = "backend:latest"
      port {
        name           = "web-backend"
        container_port = 3001
      }
    }
  }
}

data "scaleway_registry_namespace" "babyteacher_registry" {
  name = "babyteacher-registry"
  region = "fr-par"
}
data "scaleway_registry_image" "babyteacher_backend" {
  name = "backend"
  region = "fr-par"
}

provider "scaleway" {}
provider "kubernetes" {
  host                   = scaleway_k8s_cluster.this.apiserver_url
  cluster_ca_certificate = base64decode(scaleway_k8s_cluster.this.kubeconfig[0].cluster_ca_certificate)
  token                  = scaleway_k8s_cluster.this.kubeconfig[0].token
}
