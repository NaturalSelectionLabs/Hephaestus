terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.36.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7"
    }
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.258.0"
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
  grpc_web    = true
  # Configuration options
}

provider "google" {
  project = "naturalselectionlabs"
  # Configuration options
}

provider "alicloud" {
  region = "us-east-1"
}
