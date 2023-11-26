resource "scaleway_registry_namespace" "main" {
  name        = "babyteacher_registry"
  description = "Baby teacher main registry"
  is_public   = false
}
