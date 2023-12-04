terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.29.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
  }

  backend "s3" {
    key       = "tf.tfstate"
    bucket    = "babyteacher-s3"
    endpoints = { s3 = "https://s3.fr-par.scw.cloud" }
    region    = "fr-par"

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}

provider "scaleway" {}

module "cluster" {
  source             = "./cluster"
  private_network_id = module.network.vpc_id
}
module "ingress" {
  source                 = "./ingress"
  cluster_host           = module.cluster.cluster_host
  cluster_token          = module.cluster.cluster_token
  cluster_ca_certificate = module.cluster.cluster_ca_certificate
}
module "network" {
  source = "./network"
}
module "pods" {
  source     = "./pods"
  cluster_ip = module.services.cluster_ip
}
module "services" {
  source = "./services"
}

