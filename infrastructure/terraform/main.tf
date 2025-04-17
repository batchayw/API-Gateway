terraform {
  required_version = ">= 1.3.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "0.3.5"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "minikube" {
  kubernetes_version = "v1.26.1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

resource "minikube_cluster" "gateway_cluster" {
  cluster_name    = var.cluster_name
  driver          = "docker"
  nodes           = var.node_count
  cpus            = var.node_cpus
  memory          = var.node_memory
  addons          = ["ingress", "metrics-server"]
}

module "gateway" {
  source = "./modules/gateway"

  cluster_name   = minikube_cluster.gateway_cluster.cluster_name
  namespace      = var.namespace
  gateway_class  = var.gateway_class
  istio_version  = var.istio_version
}

module "httproute" {
  source = "./modules/httproute"

  namespace      = var.namespace
  gateway_name   = module.gateway.gateway_name
  depends_on     = [module.gateway]
}

module "tcproute" {
  source = "./modules/tcproute"

  namespace      = var.namespace
  gateway_name   = module.gateway.gateway_name
  depends_on     = [module.gateway]
}

module "udproute" {
  source = "./modules/udproute"

  namespace      = var.namespace
  gateway_name   = module.gateway.gateway_name
  depends_on     = [module.gateway]
}

module "cert_manager" {
  source = "./modules/cert_manager"

  namespace      = var.namespace
  email         = var.cert_manager_email
  depends_on    = [module.gateway]
}

module "network_policy" {
  source = "./modules/network_policy"

  namespace      = var.namespace
  depends_on     = [module.gateway]
}

module "monitoring" {
  source = "./modules/monitoring"

  namespace      = var.namespace
  prometheus_retention = var.prometheus_retention
  depends_on     = [module.gateway]
}

module "ingress" {
  source = "./modules/ingress"
  count  = var.enable_ingress ? 1 : 0

  namespace      = var.namespace
  domain         = var.domain
  depends_on     = [module.cert_manager]
}