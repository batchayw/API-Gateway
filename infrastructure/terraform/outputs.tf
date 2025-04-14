output "cluster_name" {
  description = "Name of the created cluster"
  value       = minikube_cluster.gateway_cluster.cluster_name
}

output "kubeconfig" {
  description = "Path to the kubeconfig file"
  value       = minikube_cluster.gateway_cluster.kubeconfig_path
  sensitive   = true
}

output "gateway_endpoint" {
  description = "Endpoint for the Gateway API"
  value       = module.gateway_api.gateway_endpoint
}