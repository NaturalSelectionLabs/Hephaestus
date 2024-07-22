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
      name      = "ops"
      namespace = "argo"
    }
  }
}

resource "argocd_application" "argocd-image-updater" {
  metadata {
    name      = "argocd-image-updater"
    namespace = "guardian"
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
      server    = argocd_cluster.prod.server
      namespace = "guardian"
    }
  }
}

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

resource "argocd_application" "cilium" {
  metadata {
    name      = "cilium"
    namespace = "guardian"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "cilium/prod"
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
      namespace = "kube-system"
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

resource "argocd_application" "discourse" {
  metadata {
    name      = "discourse"
    namespace = "guardian"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "discourse/prod"
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
      namespace = "default"
    }
  }
}

resource "argocd_application" "ipfs" {
  metadata {
    name      = "ipfs"
    namespace = "guardian"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "ipfs/prod"
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

resource "argocd_application" "shlink" {
  metadata {
    name      = "shlink"
    namespace = "guardian"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name
    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "shlink/prod"
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
      namespace = "default"
    }
  }
}

resource "argocd_application" "metabase" {
  metadata {
    name      = "metabase"
    namespace = "guardian"
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
      server    = argocd_cluster.prod.server
      namespace = "guardian"
    }
  }
}

resource "argocd_application" "novu" {
  metadata {
    name      = "novu"
    namespace = "guardian"
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