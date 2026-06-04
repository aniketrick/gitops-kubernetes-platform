output "cluster_name" {
  value = kind_cluster.gitops.name
}

output "argocd_namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}

output "app_namespace" {
  value = kubernetes_namespace.portfolio_api.metadata[0].name
}
