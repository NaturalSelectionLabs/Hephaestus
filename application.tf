resource "argocd_application" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "guardian"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
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

resource "argocd_application" "keycloak" {
  metadata {
    name      = "keycloak"
    namespace = "guardian"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
    source {
      helm {
        release_name = "keycloak"
        value_files = [
          "$values/keycloak/prod/values.yaml"
        ]
      }
      repo_url        = "https://codecentric.github.io/helm-charts"
      target_revision = "18.x.x"
      chart           = "keycloak"
    }

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      ref             = "values"
    }

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "keycloak/prod"
    }

    destination {
      server    = argocd_cluster.prod.server
      namespace = "guardian"
    }
  }
}