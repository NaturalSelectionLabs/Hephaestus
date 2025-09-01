locals {
  cluster_ids = {
    common = "c0f3a81dd784c40b1bd75f140332da998"
    folo   = "cb75cfa28dac844d6ac175e587ee60801"
  }
}

data "alicloud_cs_kubernetes_clusters" "cluster" {
  ids = [for k, v in local.cluster_ids : v]
}

output "clusters" {
  value = data.alicloud_cs_kubernetes_clusters.cluster.names
}
