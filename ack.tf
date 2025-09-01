locals {
  cluster_ids = {
    common = "c0f3a81dd784c40b1bd75f140332da998"
    folo   = "cb75cfa28dac844d6ac175e587ee60801"
  }
}

data "alicloud_cs_cluster_credential" "common" {
  cluster_id = local.cluster_ids.common
}

output "cluster_name" {
  value = data.alicloud_cs_cluster_credential.common.cluster_name
}
