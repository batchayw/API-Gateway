variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "gateway-api-cluster"
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 3
}

variable "istio_version" {
  description = "Version of Istio to install"
  type        = string
  default     = "1.17.2"
}