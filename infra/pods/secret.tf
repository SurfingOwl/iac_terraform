resource "kubernetes_secret" "backend_secret" {
  metadata {
    name = "backend-secret"
  }
  data = {
    MYSQL_USER          = var.MYSQL_USER
    MYSQL_PASSWORD      = var.MYSQL_PASSWORD
    MYSQL_ROOT_PASSWORD = var.MYSQL_ROOT_PASSWORD
    MONGO_USER          = var.MONGO_USER
    MONGO_PASSWORD      = var.MONGO_PASSWORD
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