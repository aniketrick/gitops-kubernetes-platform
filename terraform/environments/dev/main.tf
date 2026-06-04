terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.5.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "gitops" {
  name           = var.cluster_name
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      extra_port_mappings {
        container_port = 80
        host_port      = 8081
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = 443
        host_port      = 8443
        protocol       = "TCP"
      }
    }

    node {
      role = "worker"
    }
  }
}

data "kind_cluster" "gitops" {
  name       = kind_cluster.gitops.name
  depends_on = [kind_cluster.gitops]
}

provider "kubernetes" {
  host                   = data.kind_cluster.gitops.endpoint
  client_certificate     = data.kind_cluster.gitops.client_certificate
  client_key             = data.kind_cluster.gitops.client_key
  cluster_ca_certificate = data.kind_cluster.gitops.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = data.kind_cluster.gitops.endpoint
    client_certificate     = data.kind_cluster.gitops.client_certificate
    client_key             = data.kind_cluster.gitops.client_key
    cluster_ca_certificate = data.kind_cluster.gitops.cluster_ca_certificate
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "portfolio_api" {
  metadata {
    name = "portfolio-api"
  }
}

resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.10.1"

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  depends_on = [kind_cluster.gitops]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "6.7.18"

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  depends_on = [helm_release.nginx_ingress]
}
