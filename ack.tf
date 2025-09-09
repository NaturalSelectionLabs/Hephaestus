data "alicloud_cs_managed_kubernetes_clusters" "common" {
  name_regex     = "common"
  enable_details = true
}

data "alicloud_cs_managed_kubernetes_clusters" "folo" {
  name_regex     = "folo"
  enable_details = true
}

data "alicloud_cs_cluster_credential" "common" {
  cluster_id = data.alicloud_cs_managed_kubernetes_clusters.common.clusters.0.id
}

data "alicloud_cs_cluster_credential" "folo" {
  cluster_id = data.alicloud_cs_managed_kubernetes_clusters.folo.clusters.0.id
}

provider "kubernetes" {
  alias = "ack-common"

  host                   = data.alicloud_cs_managed_kubernetes_clusters.common.clusters.0.connections.api_server_internet
  client_certificate     = base64decode(data.alicloud_cs_cluster_credential.common.certificate_authority.client_cert)
  client_key             = base64decode(data.alicloud_cs_cluster_credential.common.certificate_authority.client_key)
  cluster_ca_certificate = base64decode(data.alicloud_cs_cluster_credential.common.certificate_authority.cluster_cert)
}

provider "kubernetes" {
  alias                  = "ack-folo"
  host                   = data.alicloud_cs_managed_kubernetes_clusters.folo.clusters.0.connections.api_server_internet
  client_certificate     = base64decode(data.alicloud_cs_cluster_credential.folo.certificate_authority.client_cert)
  client_key             = base64decode(data.alicloud_cs_cluster_credential.folo.certificate_authority.client_key)
  cluster_ca_certificate = base64decode(data.alicloud_cs_cluster_credential.folo.certificate_authority.cluster_cert)
}

provider "kubernetes" {
  alias                  = "ack-xlog"
  host                   = data.alicloud_cs_serverless_kubernetes_clusters.xlog.clusters.0.connections.api_server_internet
  client_certificate     = base64decode(data.alicloud_cs_cluster_credential.xlog.certificate_authority.client_cert)
  client_key             = base64decode(data.alicloud_cs_cluster_credential.xlog.certificate_authority.client_key)
  cluster_ca_certificate = base64decode(data.alicloud_cs_cluster_credential.xlog.certificate_authority.cluster_cert)
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
