output "cluster_name" {
  description = "Name of the created cluster"
  value       = minikube_cluster.gateway_cluster.cluster_name
}

output "gateway_endpoint" {
  description = "Gateway API endpoint"
  value       = module.gateway.gateway_endpoint
}

output "prometheus_url" {
  description = "Prometheus dashboard URL"
  value       = module.monitoring.prometheus_url
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = module.monitoring.grafana_url
  sensitive   = true
}

output "ingress_ip" {
  description = "Ingress controller external IP"
  value       = var.enable_ingress ? module.ingress[0].ingress_ip : null
}