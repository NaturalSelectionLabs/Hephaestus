terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.22.0"
    }
  }

  backend "oss" {
    bucket  = "rss3-ops"
    prefix  = "kubernetes/dev"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = "true"
  }
}

provider "helm" {
  kubernetes {

  }
}

provider "kubernetes" {}