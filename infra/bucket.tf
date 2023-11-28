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
      source  = "hashicorp/kubernetes"
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

resource "scaleway_vpc_private_network" "this" {
  name   = "babyteacher-private-network"
  region = "fr-par"
}

resource "scaleway_k8s_cluster" "this" {
  cni                         = "cilium"
  name                        = "babyteacher-cluster"
  version                     = "1.24.3"
  delete_additional_resources = true
  private_network_id          = scaleway_vpc_private_network.this.id
}

resource "scaleway_k8s_pool" "this" {
  cluster_id = scaleway_k8s_cluster.this.id
  name       = "babyteacher-pool"
  node_type  = "DEV1-M"
  size       = 1
}

resource "null_resource" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.this] # at least one pool here
  triggers   = {
    host                   = scaleway_k8s_cluster.this.kubeconfig[0].host
    token                  = scaleway_k8s_cluster.this.kubeconfig[0].token
    cluster_ca_certificate = scaleway_k8s_cluster.this.kubeconfig[0].cluster_ca_certificate
  }
}

resource "kubernetes_pod" "babyteacher_backend" {
  metadata {
    name   = "babyteacher-backend"
    labels = {
      app = "babyteacher-backend"
    }
  }
  spec {
    container {
      name  = "backend"
      image = data.scaleway_registry_image.this.image_id
      port {
        name           = "web-backend"
        container_port = 3001
      }
    }
  }
}

data "scaleway_registry_namespace" "this" {
  name   = "babyteacher-registry"
  region = "fr-par"

}
data "scaleway_registry_image" "this" {
  name         = "backend"
  region       = "fr-par"
  tags         = ["latest"]
  namespace_id = data.scaleway_registry_namespace.this.namespace_id
}

provider "scaleway" {}
provider "kubernetes" {
  host                   = null_resource.kubeconfig.triggers.host
  token                  = null_resource.kubeconfig.triggers.token
  cluster_ca_certificate = base64decode(
    null_resource.kubeconfig.triggers.cluster_ca_certificate
  )
}
