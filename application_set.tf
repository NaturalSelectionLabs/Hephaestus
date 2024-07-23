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
          },
          {
            cluster = argocd_cluster.ops.name
            url     = argocd_cluster.ops.server
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
          },
          {
            cluster = argocd_cluster.ops.name
            url     = argocd_cluster.ops.server
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
          kustomize {
            common_annotations = {
              "github.com/url" = var.repo_url
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
    name      = "actions-runner-controller"
    namespace = "argo"
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
          },
          {
            cluster = argocd_cluster.ops.name
            url     = argocd_cluster.ops.server
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
    name = "loki"
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

resource "argocd_application_set" "jaeger" {
  metadata {
    name = "jaeger"
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
        name = "jaeger-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }
      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "jaeger/{{cluster}}"
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

resource "argocd_application_set" "exporter" {
  metadata {
    name = "exporter"
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
        name = "exporter-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }
      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = "https://github.com/NaturalSelectionLabs/Cluster-Exporter"
          target_revision = "HEAD"
          path            = "exporters/{{cluster}}"
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

resource "argocd_application_set" "alert" {
  metadata {
    name = "alert"
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
        name = "alert-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }
      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = "https://github.com/NaturalSelectionLabs/Infrastructure-Alert"
          target_revision = "HEAD"
          path            = "{{cluster}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Infrastructure-Alert"
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

resource "argocd_application_set" "rabbitmq" {
  metadata {
    name = "rabbitmq"
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
        name = "rabbitmq-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }
      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "rabbitmq/{{cluster}}"
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

resource "argocd_application_set" "etcd" {
  metadata {
    name = "etcd"
  }
  spec {
    generator {
      list {
        elements = [
          {
            cluster = argocd_cluster.dev.name
            url     = argocd_cluster.dev.server
          },
          #          {
          #            cluster = argocd_cluster.prod.name
          #            url     = argocd_cluster.prod.server
          #          }
        ]
      }
    }
    template {
      metadata {
        name = "etcd-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }
      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "etcd/{{cluster}}"
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

resource "argocd_application_set" "pyroscope" {
  metadata {
    name = "pyroscope"
  }
  spec {
    generator {
      list {
        elements = [
          {
            cluster = argocd_cluster.dev.name
            url     = argocd_cluster.dev.server
          }
          #           {
          #             cluster = argocd_cluster.prod.name
          #             url     = argocd_cluster.prod.server
          #           }
        ]
      }
    }
    template {
      metadata {
        name = "pyroscope-{{cluster}}"
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "pyroscope/{{cluster}}"
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

resource "argocd_application_set" "argo-workflow" {
  metadata {
    name = "argo-workflow"
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
        name = "argo-workflow-{{cluster}}"
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "argo-workflow/{{cluster}}"
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