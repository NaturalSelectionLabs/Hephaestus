output "bearer_token" {
  value = kubernetes_secret.argocd_manager.data["token"]
}
