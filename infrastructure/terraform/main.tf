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

resource "minikube_cluster" "gateway_cluster" {
  cluster_name    = "gateway-api-cluster"
  driver          = "docker"
  nodes           = 3
  cpus            = 4
  memory          = 8192
  addons          = ["ingress", "metrics-server"]
}

module "gateway_api" {
  source = "./modules/gateway_api"

  cluster_name = minikube_cluster.gateway_cluster.cluster_name
}

module "monitoring" {
  source = "./modules/monitoring"

  depends_on = [module.gateway_api]
}