output "bearer_token" {
  value = data.kubernetes_secret.argocd_manager.data["token"]
}
