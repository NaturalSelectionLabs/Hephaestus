resource "argocd_cluster" "dev" {
  server = "https://${data.google_container_cluster.us_central1_dev.endpoint}"
  name   = "dev"

  config {
    exec_provider_config {
      command     = "argocd-k8s-auth"
      args        = ["gcp"]
      api_version = "client.authentication.k8s.io/v1beta1"
    }
    tls_client_config {
      insecure = false
      ca_data  = base64decode(data.google_container_cluster.us_central1_dev.master_auth[0].cluster_ca_certificate)
    }
  }

  lifecycle {
    ignore_changes = [config,metadata]
  }
}

resource "argocd_cluster" "prod" {
  server = "https://${data.google_container_cluster.us_central1_prod.endpoint}"
  name   = "prod"

  config {
    exec_provider_config {
      command     = "argocd-k8s-auth"
      args        = ["gcp"]
      api_version = "client.authentication.k8s.io/v1beta1"
    }
    tls_client_config {
      insecure = false
      ca_data  = base64decode(data.google_container_cluster.us_central1_prod.master_auth[0].cluster_ca_certificate)
    }
  }

  lifecycle {
    ignore_changes = [config,metadata]
  }
}

resource "argocd_cluster" "ops" {
  server = "https://${data.google_container_cluster.us_central1_ops.endpoint}"
  name   = "ops"

  config {
    exec_provider_config {
      command     = "argocd-k8s-auth"
      args        = ["gcp"]
      api_version = "client.authentication.k8s.io/v1beta1"
    }
    tls_client_config {
      insecure = false
      ca_data  = base64decode(data.google_container_cluster.us_central1_ops.master_auth[0].cluster_ca_certificate)
    }
  }

  lifecycle {
    ignore_changes = [config,metadata]
  }
}
