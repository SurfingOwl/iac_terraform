terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.29.0"
    }
  }

  backend "local" {
    path = "tf.tfstate"
  }
}
provider "scaleway" {
}

resource "scaleway_object_bucket" "babyteacher_s3" {
  name = "babyteacher-s3"
  tags = {
    projet = "esgi_al2"
  }
}

resource "scaleway_registry_namespace" "babyteacher_regitstry" {
  name        = "babyteacher-registry"
  description = "Baby teacher main registry"
  is_public   = false
}
