resource "argocd_cluster" "dev" {
  server = "https://47.90.210.198:6443"
  config {}
  lifecycle {
    ignore_changes = all
  }
}

resource "argocd_cluster" "prod" {

  server = "https://47.90.255.140:6443"
  config {}
  lifecycle {
    ignore_changes = all
  }
}
