resource "kubernetes_pod" "babyteacher_backend" {
  metadata {
    name   = "babyteacher-backend"
    labels = {
      app = "babyteacher-backend"
    }
  }
  spec {
    container {
      name  = "backend"
      image = "rg.fr-par.scw.cloud/babyteacher-registry/${data.scaleway_registry_image.backend.name}:latest"
      env {
        name = "MYSQL_DATABASE"
        value = "babyteacher"
      }
      env {
        name  = "MYSQL_HOST"
        value = var.mysql_dns
      }
      env {
        name  = "MYSQL_PORT"
        value = 3306
      }
      env {
        name = "MONGO_URI"
        value = "mongodb://${var.mongo_dns}:27017"
      }
      env {
        name = "MONGO_PORT"
        value = 27017
      }
      env {
        name = "PORT"
        value = 3001
      }
      env {
        name = "FRONT_URL"
        value = var.front_dns
      }
      env_from {
        secret_ref {
          name = kubernetes_secret.backend_secret.metadata[0].name
        }
      }
      port {
        name           = "web-backend"
        container_port = 3001
      }
    }
  }
}

resource "kubernetes_pod" "babyteacher_frontend" {
  metadata {
    name   = "babyteacher-frontend"
    labels = {
      app = "babyteacher-frontend"
    }
  }
  spec {
#    volume {
#      name = "nginx-config-volume"
#      config_map {
#        name = kubernetes_config_map.nginx_frontend_website_config.metadata[0].name
#      }
#    }
    container {
      name  = "frontend"
      image = "rg.fr-par.scw.cloud/babyteacher-registry/${data.scaleway_registry_image.frontend.name}:latest"
      env_from {
        secret_ref {
          name = kubernetes_secret.frontend_secret.metadata[0].name
        }
      }
      port {
        name           = "web-frontend"
        container_port = 80
      }
    }
  }
}

resource "kubernetes_pod" "babyteacher_database" {
  metadata {
    name   = "babyteacher-database"
    labels = {
      app = "babyteacher-database"
    }
  }
  spec {
    container {
      name  = "mysql"
      image = "rg.fr-par.scw.cloud/babyteacher-registry/mysql:latest"
      port {
        name           = "mysql"
        container_port = 3306
      }
    }
  }
}

resource "kubernetes_pod" "babyteacher_mongo" {
  metadata {
    name   = "babyteacher-mongo"
    labels = {
      app = "babyteacher-mongo"
    }
  }
  spec {
    container {
      name  = "mongo"
      image = "rg.fr-par.scw.cloud/babyteacher-registry/mongo:latest"
      port {
        name           = "mongo"
        container_port = 27017
      }
    }
  }
}