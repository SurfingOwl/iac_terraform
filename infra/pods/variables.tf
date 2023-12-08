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

variable "MYSQL_USER" {
  type = string
  description = "MySQL User"
}

variable "MYSQL_PASSWORD" {
  type = string
  description = "MySQL Password"
}

variable "MYSQL_ROOT_PASSWORD" {
  type = string
  description = "MySQL root Password"
}

variable "MONGO_USER" {
  type = string
  description = "Mongo User"
}

variable "MONGO_PASSWORD" {
  type = string
  description = "Mongo Password"
}
variable "FRONT_TAG" {
  type = string
  description = "Front image tag"
}
variable "BACK_TAG" {
  type = string
  description = "Back image tag"
}