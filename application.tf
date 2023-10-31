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
      helm {
        release_name = "jaeger"
        value_files = [
          "$values/jaeger/prod/values.yaml"
        ]
      }
      repo_url        = "https://jaegertracing.github.io/helm-charts"
      target_revision = "0.71.x"
      chart           = "jaeger"
    }

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      ref             = "values"
    }

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "jaeger/prod"
      kustomize {
        common_annotations = {
          "app.kubernetes.io/instance" = "jaeger"
        }
      }
    }

    destination {
      server    = argocd_cluster.prod.server
      namespace = "guardian"
    }
  }
}
