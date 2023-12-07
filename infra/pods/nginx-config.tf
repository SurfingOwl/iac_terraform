#resource "kubernetes_config_map" "nginx_frontend_website_config" {
#  metadata {
#    name = "nginx-frontend-website-config"
#  }
#
#  data = {
#    "default.conf" = file("${path.module}/config/nginx-website.conf")
#  }
#}