terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.29.0"
    }
  }
}

data "scaleway_registry_image" "backend" {
  name = "backend"
}
data "scaleway_registry_image" "frontend" {
  name = "frontend"
}
