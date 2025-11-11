resource "argocd_application" "argocd" {
  metadata {
    name      = "argocd"
    namespace = "argo"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "argocd/prod"
      kustomize {
        common_annotations = {
          "github.com/url" = "NaturalSelectionLabs/Hephaestus"
        }
      }
    }

    destination {
      name      = "common"
      namespace = "argo"
    }
  }
}

resource "argocd_application" "argocd-image-updater" {
  metadata {
    name      = "argocd-image-updater"
    namespace = "argo"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "argocd-image-updater/prod"
      plugin {
        name = "avp-kustomize"
        env {
          name  = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name  = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
    }

    destination {
      name      = argocd_cluster.common.name
      namespace = "argo"
    }
  }
}

resource "argocd_application" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "argo"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "grafana/ops"
      plugin {
        name = "avp-kustomize"
        env {
          name  = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name  = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
    }

    destination {
      name      = "common"
      namespace = "guardian"
    }
  }
}

resource "argocd_application" "keycloak" {
  metadata {
    name      = "keycloak"
    namespace = "argo"
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
          name  = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name  = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
    }

    destination {
      name      = argocd_cluster.common.name
      namespace = "guardian"
    }
  }
}

resource "argocd_application" "metabase" {
  metadata {
    name      = "metabase"
    namespace = "argo"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "metabase/prod"
      plugin {
        name = "avp-kustomize"
        env {
          name  = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name  = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
    }

    destination {
      name      = argocd_cluster.common.name
      namespace = "guardian"
    }
  }
}

resource "argocd_application" "novu" {
  metadata {
    name      = "novu"
    namespace = "argo"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "novu/prod"
      plugin {
        name = "avp-kustomize"
        env {
          name  = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name  = "AVP_SECRET"
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

resource "argocd_application" "traefik-forward-auth" {
  metadata {
    name      = "traefik-forward-auth"
    namespace = "argo"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "traefik-forward-auth"
      plugin {
        name = "avp-kustomize"
        env {
          name  = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name  = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
    }

    destination {
      name      = argocd_cluster.common.name
      namespace = "guardian"
    }
  }
}

resource "argocd_application" "consul" {
  metadata {
    name      = "consul"
    namespace = "argo"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "consul/ops"
      plugin {
        name = "avp-kustomize"
        env {
          name  = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name  = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
    }

    destination {
      name      = "ops"
      namespace = "guardian"
    }
  }
}

resource "argocd_application" "umami" {
  metadata {
    name      = "umami"
    namespace = "argo"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "umami/prod"
      plugin {
        name = "avp-kustomize"
        env {
          name  = "APP_REPO"
          value = "NaturalSelectionLabs/Hephaestus"
        }
        env {
          name  = "AVP_SECRET"
          value = "guardian:avp-prod"
        }
      }
    }

    destination {
      name      = "ops"
      namespace = "guardian"
    }
  }
}

resource "argocd_application" "vault-unseal" {
  metadata {
    name      = "vault-unseal"
    namespace = "argo"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "vault/unseal"
      kustomize {
        common_annotations = {
          "github.com/url" = var.repo_url
        }
      }
    }

    destination {
      name      = argocd_cluster.common.name
      namespace = "guardian"
    }
  }
}
