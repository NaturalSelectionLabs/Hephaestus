resource "argocd_cluster" "dev" {
  server = "https://${data.google_container_cluster.us_central1_dev.endpoint}"
  name   = "dev"

  metadata {
    labels = {
      "env"          = "dev"
      "secret"       = "avp-dev"
      "provider"     = "gcp"
      "cluster-type" = "gke-standard"
      "tenant"       = "1"
    }
  }

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

}

resource "argocd_cluster" "prod" {
  server = "https://${data.google_container_cluster.us_central1_prod.endpoint}"
  name   = "prod"

  metadata {
    labels = {
      "env"          = "prod"
      "secret"       = "avp-prod"
      "provider"     = "gcp"
      "cluster-type" = "gke-standard"
      "tenant"       = "2"
    }
  }

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

}

resource "argocd_cluster" "ops" {
  server = "https://${data.google_container_cluster.us_central1_ops.endpoint}"
  name   = "ops"

  metadata {
    labels = {
      "env"          = "ops"
      "secret"       = "avp-prod"
      "provider"     = "gcp"
      "cluster-type" = "gke-autopilot"
      "tenant"       = "0"
    }
  }

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

}

resource "argocd_cluster" "ovh" {
  server = "https://k8s.ovh.naturalselectionlabs.com"
  name   = "ovh"

  metadata {
    labels = {
      "env"          = "ovh"
      "secret"       = "avp-ovh"
      "provider"     = "ovh"
      "cluster-type" = "rke2"
      "tenant"       = "3"
    }
  }

  config {
    bearer_token = var.OVH_TOKEN
    tls_client_config {
      ca_data = base64decode(var.OVH_CA_DATA)
    }
  }
}


resource "argocd_cluster" "folo" {
  server = var.FOLO_SERVER_URL
  name   = "folo"

  metadata {
    labels = {
      "env"          = "folo"
      "secret"       = "avp-folo"
      "provider"     = "alicloud"
      "cluster-type" = "ack"
    }
  }
  config {
    bearer_token = var.FOLO_TOKEN
    tls_client_config {
      ca_data = base64decode(var.FOLO_CA_DATA)
    }
  }
}
