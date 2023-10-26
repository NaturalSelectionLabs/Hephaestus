resource "argocd_repository" "victoria_metrics" {
  repo = "https://victoriametrics.github.io/helm-charts/"
  type = "helm"
  name = "vm"
}

resource "argocd_repository" "hashicorp" {
  repo = "https://helm.releases.hashicorp.com"
  type = "helm"
  name = "hashicorp"
}

resource "argocd_repository" "bitnami" {
  repo = "https://charts.bitnami.com/bitnami"
  type = "helm"
  name = "bitnami"
}