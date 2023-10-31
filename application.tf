resource "argocd_application" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "guardian"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "grafana/prod"
      plugin {
        name = "avp-kustomize"
        env {
          name = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
    }

    destination {
      server    = argocd_cluster.prod.server
      namespace = "guardian"
    }
  }
}

resource "argocd_application" "loki" {
  metadata {
    name      = "loki"
    namespace = "guardian"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "loki/prod"
      plugin {
        name = "avp-kustomize"
        env {
          name = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
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
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "keycloak/prod"
      plugin {
        name = "avp-kustomize"
        env {
          name = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
    }

    destination {
      server    = argocd_cluster.prod.server
      namespace = "guardian"
    }
  }
}

resource "argocd_application" "jaeger" {
  metadata {
    name      = "jaeger"
    namespace = "guardian"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "jaeger/prod"
      plugin {
        name = "avp-kustomize"
        env {
          name = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
    }

    destination {
      server    = argocd_cluster.prod.server
      namespace = "guardian"
    }
  }
}
