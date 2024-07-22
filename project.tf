resource "argocd_project" "guardian" {
  metadata {
    name      = "guardian"
    namespace = "guardian"
  }

  spec {
    source_namespaces = ["default", "guardian", "kube-system"]
    source_repos      = ["*"]

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
    destination {
      server    = "*"
      namespace = "*"
    }
  }
}

resource "argocd_project" "namespaced" {
  for_each = toset([
    "ai",
    "copilot",
    "crossbell",
    "network",
    "pregod",
    "search",
    "diygod",
    "follow"
  ])

  metadata {
    name      = each.value
    namespace = "guardian"
  }

  spec {
    source_namespaces = [each.value]
    source_repos      = ["*"]

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
    destination {
      server    = argocd_cluster.prod.server
      namespace = "*"
    }
    destination {
      server    = argocd_cluster.dev.server
      namespace = "*"
    }
  }
}