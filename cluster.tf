resource "argocd_cluster" "dev" {
  server = "https://${data.google_container_cluster.us_central1_dev.endpoint}"
  name   = "dev"

  lifecycle {
    ignore_changes = [
      config.tls_client_config.ca_data
    ]
  }

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
  lifecycle {
    ignore_changes = [
      config.tls_client_config.ca_data
    ]
  }

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

  lifecycle {
    ignore_changes = [
      config.tls_client_config.ca_data
    ]
  }

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
      "region"       = "ca-bhs"
      "tenant"       = "3"
    }
  }

  config {
    bearer_token = module.ovh-argocd-manager.bearer_token
    tls_client_config {
      ca_data = base64decode(var.OVH_CA_DATA)
    }
  }
}


resource "argocd_cluster" "folo" {
  server = data.alicloud_cs_managed_kubernetes_clusters.folo.clusters.0.connections.api_server_internet
  name   = "folo"

  metadata {
    labels = {
      "env"          = "folo"
      "secret"       = "avp-folo"
      "provider"     = "alicloud"
      "region"       = "us-east-1"
      "cluster-type" = "ack"
    }
  }
  config {
    bearer_token = module.folo-argocd-manager.bearer_token
    tls_client_config {
      ca_data = base64decode(data.alicloud_cs_cluster_credential.folo.certificate_authority.cluster_cert)
    }
  }
}

resource "argocd_cluster" "common" {
  server = data.alicloud_cs_managed_kubernetes_clusters.common.clusters.0.connections.api_server_internet
  name   = "common"

  metadata {
    labels = {
      "env"          = "common"
      "secret"       = "avp-common"
      "provider"     = "alicloud"
      "region"       = "us-east-1"
      "cluster-type" = "ack"
    }
  }
  config {
    bearer_token = module.common-argocd-manager.bearer_token
    tls_client_config {
      ca_data = base64decode(data.alicloud_cs_cluster_credential.common.certificate_authority.cluster_cert)
    }
  }
}
