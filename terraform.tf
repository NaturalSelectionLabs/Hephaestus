terraform {
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "6.0.3"
    }
  }
  backend "oss" {
    bucket  = "rss3-ops"
    prefix  = "infrastructure/argocd"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = "true"
  }
}

provider "argocd" {
  server_addr = "argocd.nsl.xyz:443"
  username    = "admin"
  password    = var.ARGOCD_PASSWORD
  # Configuration options
}
