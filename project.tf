resource "argocd_project" "guardian" {
  metadata {
    name      = "guardian"
    namespace = "argo"
  }

  spec {
    source_namespaces = ["*"]
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
    "aa",
    "copilot",
    "crossbell",
    "network",
    "pregod",
    "search",
    "diygod",
    "follow",
    "overlord",
    "rsshub"
  ])

  metadata {
    name      = each.value
    namespace = "argo"
  }

  spec {
    source_namespaces = [each.value]
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
