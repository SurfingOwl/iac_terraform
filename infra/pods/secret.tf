resource "kubernetes_secret" "backend_secret" {
  metadata {
    name = "backend-secret"
  }
  data = {
    MYSQL_USER          = "babyuser" # A MODIFIER
    MYSQL_PASSWORD      = "pass" # A MODIFIER
    MYSQL_ROOT_PASSWORD = "pass" # A MODIFIER
    MONGO_USER          = "babyUser"   # A MODIFIER
    MONGO_PASSWORD      = "toto" # A MODIFIER
  }
  type = "Opaque"
}

resource "kubernetes_secret" "frontend_secret" {
  metadata {
    name = "frontend-secret"
  }
  data = {
    BACKEND_URL = var.front_dns
  }
  type = "Opaque"
}