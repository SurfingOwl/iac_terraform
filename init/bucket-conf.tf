terraform {
  backend "local" {
    path = "tf.tfstate"
  }
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.29.0"
    }
  }
}

provider "scaleway" {
}

resource "scaleway_object_bucket" "babyteacher" {
  name = "esgi-iac-babyteacher"
  tags = {
    demo = "esgi"
  }
}

output "endpoint" {
  value = "scaleway_object_bucket.babyteacher.endpoint"
}