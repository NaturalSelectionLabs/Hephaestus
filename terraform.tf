terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.10.0"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "6.0.3"
    }
  }
  backend "gcs" {
    bucket = "nsl-ops"
    prefix = "infrastructure/argocd"
  }
}

provider "argocd" {
  server_addr = var.ARGOCD_SERVER
  username    = "admin"
  password    = var.ARGOCD_PASSWORD
  # Configuration options
}

provider "google" {
  project = "naturalselectionlabs"
  # Configuration options
}