terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.29.0"
    }
  }

#  backend "s3" {
#    key       = "tf.tfstate"
#    bucket    = "babyteacher-state"
#    endpoints = { s3 = "https://s3.fr-par.scw.cloud" }
#    region    = "fr-par"
#
#    skip_credentials_validation = true
#    skip_region_validation      = true
#  }
}

provider "scaleway" {
}

resource "scaleway_object_bucket" "babyteacher-bucket" {
  name = "babyteacher_bucket"
  tags = {
    projet = "esgi_al2"
  }
}

resource "scaleway_registry_namespace" "babyteacher-regitstry" {
  name        = "babyteacher_registry"
  description = "Baby teacher main registry"
  is_public   = false
}

output "endpoint" {
  value = "scaleway_object_bucket.babyteacher-state.endpoint"
}