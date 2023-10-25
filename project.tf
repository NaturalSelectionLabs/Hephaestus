resource "argocd_project" "guardian" {
  metadata {
    name = "guardian"
    namespace = "guardian"
  }

  spec {
    source_namespaces = ["default", "guardian"]
    source_repos = ["*"]

    cluster_resource_whitelist {
      group = "*"
      kind = "*"
    }

    destination {
      server = argocd_cluster.prod.server
      namespace = "*"
    }

    destination {
      server = argocd_cluster.dev.server
      namespace = "*"
    }

  }

}