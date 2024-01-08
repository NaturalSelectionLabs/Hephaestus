resource "argocd_application" "argocd" {
  metadata {
    name      = "argocd"
    namespace = "guardian"
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

resource "argocd_application" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = "guardian"
  }
  spec {
    project = argocd_project.guardian.metadata[0].name

    source {
      repo_url        = var.repo_url
      target_revision = "HEAD"
      path            = "rabbitmq/prod"
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
      namespace = "default"
    }
  }
}