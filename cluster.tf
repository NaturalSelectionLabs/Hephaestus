resource "argocd_cluster" "dev" {
  server = "https://${data.google_container_cluster.us_central1_dev.endpoint}"
  name = "dev"

  config {
    bearer_token = data.google_client_config.default.access_token
    tls_client_config {
      ca_data = base64decode(data.google_container_cluster.us_central1_dev.master_auth[0].cluster_ca_certificate)
    }
  }
}

resource "argocd_cluster" "prod" {
  server = "https://${data.google_container_cluster.us_central1_prod.endpoint}"
  name = "prod"

  config {
    bearer_token = data.google_client_config.default.access_token
    tls_client_config {
      ca_data = base64decode(data.google_container_cluster.us_central1_prod.master_auth[0].cluster_ca_certificate)
    }
  }
}
