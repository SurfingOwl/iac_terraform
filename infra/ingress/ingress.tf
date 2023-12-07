resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  wait       = true
  timeout    = 600
  version    = "4.5.2"
}

resource "kubernetes_ingress_v1" "ingress_controller" {
  metadata {
    name        = "ingress-controller"
    annotations = {
      "nginx.ingress.kubernetes.io/use-regex"      = "true"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "false"
    }
  }
  wait_for_load_balancer = true
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path      = "/api"
          path_type = "Prefix"
          backend {
            service {
              name = var.backend_service_name
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
          path      = "/home/(/|$)(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = var.frontend_service_name
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
