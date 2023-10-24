resource "argocd_application" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "guardian"
  }
  spec {
    source {
      helm {
        release_name = "grafana"
        value_files = [
          "$values/grafana/prod/values.yaml"
        ]
      }
      repo_url        = "https://grafana.github.io/helm-charts"
      target_revision = "6.61.x"
      chart           = "grafana"
    }

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      ref             = "values"
    }

    destination {
      server    = argocd_cluster.prod.server
      namespace = "guardian"
    }
  }
}