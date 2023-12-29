data "google_client_config" "default" {}

data "google_container_cluster" "us_central1_dev" {
  name     = "us-central1-dev"
  location = "us-central1"
}

data "google_container_cluster" "us_central1_prod" {
  name     = "us-central1-prod"
  location = "us-central1"
}

provider "kubernetes" {
  alias                  = "us-central1-dev"
  host                   = "https://${data.google_container_cluster.us_central1_dev.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.us_central1_dev.master_auth[0].cluster_ca_certificate)
}

provider "kubernetes" {
  alias                  = "us-central1-prod"
  host                   = "https://${data.google_container_cluster.us_central1_prod.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.us_central1_prod.master_auth[0].cluster_ca_certificate)
}
