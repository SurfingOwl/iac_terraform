terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.29.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }
  }

  backend "s3" {
    key       = "tf.tfstate"
    bucket    = "babyteacher-s3"
    endpoints = { s3 = "https://s3.fr-par.scw.cloud" }
    region    = "fr-par"

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}

resource "scaleway_vpc_private_network" "vpc" {
  name   = "babyteacher-private-network"
  region = "fr-par"
}

resource "scaleway_k8s_cluster" "this" {
  cni                         = "cilium"
  name                        = "babyteacher-cluster"
  version                     = "1.24.3"
  delete_additional_resources = true
  private_network_id          = scaleway_vpc_private_network.vpc.id
}

resource "scaleway_k8s_pool" "this" {
  cluster_id = scaleway_k8s_cluster.this.id
  name       = "babyteacher-pool"
  node_type  = "DEV1-M"
  size       = 1
}

resource "null_resource" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.this]
  triggers   = {
    host                   = scaleway_k8s_cluster.this.kubeconfig[0].host
    token                  = scaleway_k8s_cluster.this.kubeconfig[0].token
    cluster_ca_certificate = scaleway_k8s_cluster.this.kubeconfig[0].cluster_ca_certificate
  }
}

resource "kubernetes_service" "backend_service" {
  depends_on = [kubernetes_pod.babyteacher_backend]
  metadata {
    name = "babyteacher-backend"
  }
  spec {
    selector = {
      app = "babyteacher-backend"
    }
    port {
      port        = 3001
      target_port = 3001
    }
  }
}

resource "kubernetes_service" "frontend_service" {
  depends_on = [kubernetes_pod.babyteacher_frontend]
  metadata {
    name = "babyteacher-frontend"
  }
  spec {
    selector = {
      app = "babyteacher-frontend"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_service" "database_service" {
  depends_on = [kubernetes_pod.babyteacher_database]
  metadata {
    name = "babyteacher-database"
  }
  spec {
    selector = {
      app = "babyteacher-database"
    }
    port {
      port        = 3306
      target_port = 3306
    }
  }
}

resource "kubernetes_service" "mongo_service" {
  depends_on = [kubernetes_pod.babyteacher_mongo]
  metadata {
    name = "babyteacher-mongo"
  }
  spec {
    selector = {
      app = "babyteacher-mongo"
    }
    port {
      port        = 27017
      target_port = 27017
    }
  }
}

resource "kubernetes_secret" "backend_secret" {
  depends_on = [kubernetes_service.database_service, kubernetes_service.frontend_service]
  metadata {
    name = "backend-secret"
  }
  data = {
    username            = ""
    password            = ""
    MYSQL_DATABASE      = "babyteacher" # A MODIFIER
    MYSQL_USER          = "babyuser" # A MODIFIER
    MYSQL_PASSWORD      = "pass" # A MODIFIER
    MYSQL_ROOT_PASSWORD = "pass" # A MODIFIER
    MONGO_URI           = "mongodb://${kubernetes_service.mongo_service.spec[0].cluster_ip}:27017" # A MODIFIER
    MONGO_USER          = "babyUser"   # A MODIFIER
    MONGO_PASSWORD      = "toto" # A MODIFIER
    MSQL_HOST           = kubernetes_service.database_service.spec[0].cluster_ip # A MODIFIER
    MONGO_PORT          = 27017 # A MODIFIER
    PORT                = 3001  # A MODIFIER
    FRONT_URL           = "${kubernetes_service.frontend_service.spec[0].cluster_ip}:4200" # A MODIFIER
  }
  type = "kubernetes.io/basic-auth"
}

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
      image = "rg.fr-par.scw.cloud/babyteacher-registry/backend:latest"
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
    container {
      name  = "frontend"
      image = "rg.fr-par.scw.cloud/babyteacher-registry/frontend:latest"
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

provider "scaleway" {}
provider "helm" {}
provider "kubernetes" {
  host                   = null_resource.kubeconfig.triggers.host
  token                  = null_resource.kubeconfig.triggers.token
  cluster_ca_certificate = base64decode(
    null_resource.kubeconfig.triggers.cluster_ca_certificate
  )
}

resource "scaleway_lb_ip" "nginx_ip" {
  depends_on = [
    kubernetes_service.backend_service,
    kubernetes_service.database_service,
    kubernetes_service.mongo_service,
    kubernetes_service.frontend_service
  ]
  zone       = "fr-par-1"
  project_id = scaleway_k8s_cluster.this.project_id
}

resource "helm_release" "nginx_ingress" {
  depends_on = [scaleway_lb_ip.nginx_ip]
  name       = "nginx-ingress"
  namespace  = "ingress-nginx"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true
  wait             = true
  timeout          = 600

#  set {
#    name = "controller.service.loadBalancerIP"
#    value = scaleway_lb_ip.nginx_ip.ip_address
#  }
#  set {
#    name = "controller.config.use-proxy-protocol"
#    value = "true"
#  }
#  set {
#    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-proxy-protocol-v2"
#    value = "true"
#  }
#  set {
#    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-zone"
#    value = scaleway_lb_ip.nginx_ip.zone
#  }
#  set {
#    name = "controller.service.externalTrafficPolicy"
#    value = "Local"
#  }
}

resource "kubernetes_ingress_v1" "ingress_controller" {
  depends_on = [helm_release.nginx_ingress]
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
