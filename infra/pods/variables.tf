variable "cluster_ip" {
  type = string
  description = "Kubernetes cluster ip"
}

variable "mysql_dns" {
  type = string
  description = "MySQL DNS"
}

variable "front_dns" {
  type = string
  description = "Front DNS"
}

variable "mongo_dns" {
  type = string
  description = "Mongo DNS"
}