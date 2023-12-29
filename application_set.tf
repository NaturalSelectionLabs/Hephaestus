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
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "traefik/{{cluster}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name  = "AVP_SECRET"
              value = "guardian:avp-{{cluster}}"
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
        project = argocd_project.guardian.metadata[0].name
        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "traefik-mesh/{{cluster}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name  = "AVP_SECRET"
              value = "guardian:avp-{{cluster}}"
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

resource "argocd_application_set" "victoria_metrics" {
  metadata {
    name = "victoriametrics"
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
        name = "victoriametrics-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "victoriametrics/{{cluster}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name  = "AVP_SECRET"
              value = "guardian:avp-{{cluster}}"
            }
          }
        }

        ignore_difference {
          group = "*"
          kind  = "Service"
          jq_path_expressions = [
            ".spec.ports[].nodePort"
          ]
        }

        destination {
          server    = "{{url}}"
          namespace = "guardian"
        }

        sync_policy {
          sync_options = ["ServerSideApply=true"]
        }
      }
    }
  }
}

resource "argocd_application_set" "actions_runner_controller" {
  metadata {
    name = "actions-runner-controller"
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
        name = "actions-runner-controller-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name
        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "actions-runner-controller/{{cluster}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name  = "AVP_SECRET"
              value = "guardian:avp-{{cluster}}"
            }
          }
        }

        ignore_difference {
          group               = "admissionregistration.k8s.io"
          kind                = "*"
          jq_path_expressions = [".webhooks[].clientConfig.caBundle"]
        }

        destination {
          server    = "{{url}}"
          namespace = "guardian"
        }

        sync_policy {
          sync_options = ["ServerSideApply=true"]
        }

      }
    }
  }
}

resource "argocd_application_set" "apisix" {
  metadata {
    name = "apisix"
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
        name = "apisix-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name


        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "apisix/{{cluster}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name  = "AVP_SECRET"
              value = "guardian:avp-{{cluster}}"
            }
          }
        }

        destination {
          server    = "{{url}}"
          namespace = "guardian"
        }

        ignore_difference {
          group = "*"
          kind  = "CustomResourceDefinition"
          jq_path_expressions = [
            ".spec.versions[].additionalPrinterColumns[].priority"
          ]
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
        project = argocd_project.guardian.metadata[0].name


        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "cert-manager/{{cluster}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name  = "AVP_SECRET"
              value = "guardian:avp-{{cluster}}"
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

#resource "argocd_application_set" "consul" {
#  metadata {
#    name = "consul"
#  }
#  spec {
#    generator {
#      list {
#        elements = [
#          {
#            cluster = argocd_cluster.dev.name
#            url     = argocd_cluster.dev.server
#          },
#          #          {
#          #            cluster = argocd_cluster.prod.name
#          #            url     = argocd_cluster.prod.server
#          #          }
#        ]
#      }
#    }
#    template {
#      metadata {
#        name = "consul-{{cluster}}"
#        labels = {
#          cluster = "{{cluster}}"
#        }
#      }
#
#      spec {
#        project = argocd_project.guardian.metadata[0].name
#
#        source {
#          repo_url        = var.repo_url
#          target_revision = "HEAD"
#          path            = "consul/{{cluster}}"
#          plugin {
#            name = "avp-kustomize"
#            env {
#              name = "APP_REPO"
#              value = "NaturalSelectionLabs/Hephaestus"
#            }
#            env {
#              name = "AVP_SECRET"
#              value = "guardian:avp-{{cluster}}"
#            }
#          }
#        }
#
#        destination {
#          server    = "{{url}}"
#          namespace = "guardian"
#        }
#
#      }
#    }
#  }
#}

resource "argocd_application_set" "crdb" {
  metadata {
    name = "crdb"
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
        name = "crdb-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "crdb/{{cluster}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name  = "AVP_SECRET"
              value = "guardian:avp-{{cluster}}"
            }
          }
        }

        destination {
          server    = "{{url}}"
          namespace = "default"
        }

      }
    }
  }
}

resource "argocd_application_set" "kafka" {
  metadata {
    name = "kafka"
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
        name = "kafka-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "kafka/{{cluster}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name  = "AVP_SECRET"
              value = "guardian:avp-{{cluster}}"
            }
          }
        }

        ignore_difference {
          group = "*"
          kind  = "Service"
          jq_path_expressions = [
            ".spec.ports[].nodePort"
          ]
        }

        destination {
          server    = "{{url}}"
          namespace = "guardian"
        }

      }
    }
  }
}

resource "argocd_application_set" "loki" {
  metadata {
    name      = "loki"
    namespace = "guardian"
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
        name = "loki-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }
      spec {
        project = argocd_project.guardian.metadata[0].name
        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "loki/{{cluster}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name  = "AVP_SECRET"
              value = "guardian:avp-{{cluster}}"
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