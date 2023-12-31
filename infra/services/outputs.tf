output "mysql_dns" {
  value = "${kubernetes_service.database_service.metadata.0.name}.${kubernetes_service.database_service.metadata.0.namespace}.svc.cluster.local"
}

output "front_dns" {
  value = "${kubernetes_service.frontend_service.metadata.0.name}.${kubernetes_service.frontend_service.metadata.0.namespace}.svc.cluster.local"
}

output "mongo_dns" {
  value = "${kubernetes_service.mongo_service.metadata.0.name}.${kubernetes_service.mongo_service.metadata.0.namespace}.svc.cluster.local"
}

output "backend_service_name" {
  value = kubernetes_service.backend_service.metadata.0.name
}

output "frontend_service_name" {
  value = kubernetes_service.frontend_service.metadata.0.name
}