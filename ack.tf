locals {
  cluster_ids = {
    common = "c0f3a81dd784c40b1bd75f140332da998"
    folo   = "cb75cfa28dac844d6ac175e587ee60801"
  }
}

data "alicloud_cs_kubernetes_clusters" "common" {
  ids            = [local.cluster_ids.common]
  enable_details = true
}

data "alicloud_cs_kubernetes_clusters" "folo" {
  ids            = [local.cluster_ids.folo]
  enable_details = true
}

data "alicloud_cs_cluster_credential" "common" {
  cluster_id = local.cluster_ids.common
}

data "alicloud_cs_cluster_credential" "folo" {
  cluster_id = local.cluster_ids.folo
}

provider "kubernetes" {
  alias = "ack-common"

  host                   = data.alicloud_cs_kubernetes_clusters.common.clusters.0.connections.api_server_internet
  client_certificate     = data.alicloud_cs_cluster_credential.common.certificate_authority.client_cert
  client_key             = data.alicloud_cs_cluster_credential.common.certificate_authority.client_key
  cluster_ca_certificate = data.alicloud_cs_cluster_credential.common.certificate_authority.cluster_cert
}

provider "kubernetes" {
  alias                  = "ack-folo"
  host                   = data.alicloud_cs_kubernetes_clusters.folo.clusters.0.connections.api_server_internet
  client_certificate     = data.alicloud_cs_cluster_credential.folo.certificate_authority.client_cert
  client_key             = data.alicloud_cs_cluster_credential.folo.certificate_authority.client_key
  cluster_ca_certificate = data.alicloud_cs_cluster_credential.folo.certificate_authority.cluster_cert
}

module "folo-argocd-manager" {
  source = "./modules/argocd-manager"
  providers = {
    kubernetes = kubernetes.ack-folo
  }
}

module "common-argocd-manager" {
  source = "./modules/argocd-manager"
  providers = {
    kubernetes = kubernetes.ack-common
  }
}
