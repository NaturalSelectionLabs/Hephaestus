resource "argocd_repository" "victoria_metrics" {
  repo = "https://victoriametrics.github.io/helm-charts/"
  type = "helm"
  name = "vm"
}