#resource "kubernetes_secret" "backend_secret" {
#  metadata {
#    name = "backend-secret"
#  }
#  data = {
#    username            = ""
#    password            = ""
#    MYSQL_DATABASE      = "babyteacher" # A MODIFIER
#    MYSQL_USER          = "babyuser" # A MODIFIER
#    MYSQL_PASSWORD      = "pass" # A MODIFIER
#    MYSQL_ROOT_PASSWORD = "pass" # A MODIFIER
#    MONGO_URI           = "mongodb://${var.cluster_ip}:27017" # A MODIFIER
#    MONGO_USER          = "babyUser"   # A MODIFIER
#    MONGO_PASSWORD      = "toto" # A MODIFIER
#    MSQL_HOST           = var.cluster_ip # A MODIFIER
#    MONGO_PORT          = 27017 # A MODIFIER
#    PORT                = 3001  # A MODIFIER
#    FRONT_URL           = "${var.cluster_ip}:80" # A MODIFIER
#  }
#  type = "kubernetes.io/basic-auth"
#}