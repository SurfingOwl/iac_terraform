provider "helm" {
  kubernetes {
    host                   = var.cluster_host
    token                  = var.cluster_token
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  wait       = true
  timeout    = 600
  version = "4.5.2"
}

resource "kubernetes_ingress_v1" "ingress_controller" {
  metadata {
    name = "ingress-controller"
  }
  spec {
    ingress_class_name = "nginx"
#    rule {
#      http {
#        path {
#          path = "/api"
#          backend {
#            service {
#              name = "backend-service"
#              port {
#                number = 3001
#              }
#            }
#          }
#        }
#      }
#    }
#    rule {
#      http {
#        path {
#          path = "/"
#          backend {
#            service {
#              name = "frontend-service"
#              port {
#                number = 80
#              }
#            }
#          }
#        }
#      }
#    }
  }
}
