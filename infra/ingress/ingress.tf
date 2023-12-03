resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = "ingress-nginx"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = false
  wait             = true
  timeout          = 600

}

resource "kubernetes_ingress_v1" "ingress_controller" {
  metadata {
    name = "ingress-controller"
  }
  spec {
    rule {
      http {
        path {
          path = "/api"
          backend {
            service {
              name = "backend-service"
              port {
                number = 3001
              }
            }
          }
        }
      }
    }
    rule {
      http {
        path {
          path = "/"
          backend {
            service {
              name = "frontend-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
