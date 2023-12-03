terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.29.0"
    }
  }
}

resource "scaleway_vpc_private_network" "vpc" {
  name   = "babyteacher-private-network"
  region = "fr-par"
}

