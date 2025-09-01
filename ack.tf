locals {
  cluster_ids = {
    common = "c0f3a81dd784c40b1bd75f140332da998"
    folo   = "cb75cfa28dac844d6ac175e587ee60801"
  }
}

data "alicloud_cs_cluster_credential" "common" {
  cluster_id = local.cluster_ids.common
}

data "alicloud_cs_cluster_credential" "folo" {
  cluster_id = local.cluster_ids.folo
}

provider "kubernetes" {
  alias                  = "ack-common"
  host                   = data.alicloud_cs_cluster_credential.common.kube_config.host
  token                  = data.alicloud_cs_cluster_credential.common.kube_config.token
  cluster_ca_certificate = base64decode(data.alicloud_cs_cluster_credential.common.kube_config.cluster_ca_certificate)
}

provider "kubernetes" {
  alias                  = "ack-folo"
  host                   = data.alicloud_cs_cluster_credential.folo.kube_config.host
  token                  = data.alicloud_cs_cluster_credential.folo.kube_config.token
  cluster_ca_certificate = base64decode(data.alicloud_cs_cluster_credential.folo.kube_config.cluster_ca_certificate)
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
