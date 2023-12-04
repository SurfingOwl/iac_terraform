#resource "kubernetes_service" "backend_service" {
#  metadata {
#    name = "babyteacher-backend"
#  }
#  spec {
#    selector = {
#      app = "babyteacher-backend"
#    }
#    port {
#      port        = 3001
#      target_port = 3001
#    }
#  }
#}
#
#resource "kubernetes_service" "frontend_service" {
#  metadata {
#    name = "babyteacher-frontend"
#  }
#  spec {
#    selector = {
#      app = "babyteacher-frontend"
#    }
#    port {
#      port        = 80
#      target_port = 80
#    }
#  }
#}
#
#resource "kubernetes_service" "database_service" {
#  metadata {
#    name = "babyteacher-database"
#  }
#  spec {
#    selector = {
#      app = "babyteacher-database"
#    }
#    port {
#      port        = 3306
#      target_port = 3306
#    }
#  }
#}
#
#resource "kubernetes_service" "mongo_service" {
#  metadata {
#    name = "babyteacher-mongo"
#  }
#  spec {
#    selector = {
#      app = "babyteacher-mongo"
#    }
#    port {
#      port        = 27017
#      target_port = 27017
#    }
#  }
#}
