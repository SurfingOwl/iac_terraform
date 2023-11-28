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

resource "scaleway_object_bucket" "babyteacher_bucket" {
  name = "babyteacher-bucket"
  tags = {
    projet = "esgi_al2"
  }
}

resource "scaleway_registry_namespace" "babyteacher_regitstry" {
  name        = "babyteacher-registry"
  description = "Baby teacher main registry"
  is_public   = false
}

output "endpoint" {
  value = "scaleway_object_bucket.babyteacher-state.endpoint"
}