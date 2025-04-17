variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "gateway-api-cluster"
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 5
}

variable "node_cpus" {
  description = "Nombre de CPUs par nœud"
  type        = number
  default     = 4
}

variable "node_memory" {
  description = "Mémoire par nœud (en MB)"
  type        = number
  default     = 16384
}

variable "namespace" {
  description = "Namespace for deployment"
  type        = string
  default     = "gateway-system"
}

variable "gateway_class" {
  description = "Gateway class name"
  type        = string
  default     = "istio"
}

variable "istio_version" {
  description = "Version of Istio to install"
  type        = string
  default     = "1.17.2"
}

variable "cert_manager_email" {
  description = "Email for Let's Encrypt registration"
  type        = string
  default     = "admin@example.com"
}

variable "prometheus_retention" {
  description = "Prometheus metrics retention period"
  type        = string
  default     = "7d"
}

variable "enable_ingress" {
  description = "Enable NGINX Ingress Controller"
  type        = bool
  default     = false
}

variable "domain" {
  description = "Base domain for ingress"
  type        = string
  default     = "example.com"
}