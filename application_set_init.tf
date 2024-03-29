resource "argocd_application_set" "vault" {
  metadata {
    name = "vault"
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
        name = "vault-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "vault/{{cluster}}"
          kustomize {
            common_annotations = {
              "github.com/url" = var.repo_url
            }
          }
        }

        destination {
          server    = "{{url}}"
          namespace = "guardian"
        }
      }
    }
  }
}