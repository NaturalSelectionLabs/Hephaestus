resource "argocd_application_set" "traefik" {
  metadata {
    name = "traefik"
  }
  spec {
    generator {
      list {
        elements = [
          {
            cluster = argocd_cluster.dev.name
            url     = argocd_cluster.dev.server
          },
          {
            cluster = argocd_cluster.prod.name
            url     = argocd_cluster.prod.server
          }
        ]
      }
    }
    template {
      metadata {
        name = "traefik-{{cluster}}"
      }

      spec {
        source {
          helm {
            release_name = "traefik"
            value_files = [
              "$values/traefik/{{cluster}}/values.yaml"
            ]
          }
          repo_url        = "https://helm.traefik.io/traefik"
          target_revision = "22.x.x"
          chart           = "traefik"
        }
        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          ref             = "values"
        }

        destination {
          server    = "{{url}}"
          namespace = "default"
        }
      }
    }
  }
}

resource "argocd_application_set" "traefik_mesh" {
  metadata {
    name = "traefik-mesh"
  }
  spec {
    generator {
      list {
        elements = [
          {
            cluster = argocd_cluster.dev.name
            url     = argocd_cluster.dev.server
          },
          {
            cluster = argocd_cluster.prod.name
            url     = argocd_cluster.prod.server
          }
        ]
      }
    }
    template {
      metadata {
        name = "traefik-mesh-{{cluster}}"
      }

      spec {
        source {
          helm {
            release_name = "traefik-mesh"
            value_files = [
              "$values/traefik-mesh/{{cluster}}/values.yaml"
            ]
          }
          repo_url        = "https://helm.traefik.io/traefik"
          target_revision = "4.x.x"
          chart           = "traefik-mesh"
        }
        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          ref             = "values"
        }

        destination {
          server    = "{{url}}"
          namespace = "default"
        }
      }
    }
  }
}

resource "argocd_application_set" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
  spec {
    generator {
      list {
        elements = [
          {
            cluster = argocd_cluster.dev.name
            url     = argocd_cluster.dev.server
          },
          {
            cluster = argocd_cluster.prod.name
            url     = argocd_cluster.prod.server
          }
        ]
      }
    }
    template {
      metadata {
        name = "cert-manager-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }

      spec {
        source {
          helm {
            release_name = "cert-manager"
            value_files = [
              "$values/cert-manager/{{cluster}}/values.yaml"
            ]
          }
          repo_url        = "https://charts.jetstack.io"
          target_revision = "1.11.0"
          chart           = "cert-manager"
        }
        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          ref             = "values"
        }

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "cert-manager/{{cluster}}"
        }

        destination {
          server    = "{{url}}"
          namespace = "guardian"
        }
      }
    }
  }
}
