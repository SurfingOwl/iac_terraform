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
    skip_metadata_api_check     = true
  }
}

provider "scaleway" {}
provider "kubernetes" {
  host                   = module.cluster.cluster_host
  token                  = module.cluster.cluster_token
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
}
provider "helm" {
  kubernetes {
    host                   = module.cluster.cluster_host
    token                  = module.cluster.cluster_token
    cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
  }
}

module "cluster" {
  source             = "./cluster"
  private_network_id = module.network.vpc_id
}
module "ingress" {
  source = "./ingress"
}
module "network" {
  source = "./network"
}
module "pods" {
  source     = "./pods"
  cluster_ip = module.ingress.cluster_ip
  mysql_dns = module.services.mysql_dns
  front_dns = module.services.front_dns
  mongo_dns = module.services.mongo_dns
}
module "services" {
  source = "./services"
}

