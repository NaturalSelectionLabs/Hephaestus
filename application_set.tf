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
        project = argocd_project.guardian.metadata[0].name
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
          helm {
            release_name = "victoriametrics"
            value_files = [
              "$values/victoriametrics/{{cluster}}/values.yaml"
            ]
          }
          repo_url        = argocd_repository.victoria_metrics.repo
          target_revision = "0.x.x"
          chart           = "victoria-metrics-k8s-stack"
        }
        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          ref             = "values"
        }

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "victoriametrics/{{cluster}}"
          kustomize {
            common_annotations = {
              "app.kubernetes.io/instance" = "victoriametrics"
            }
          }
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
              name = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name = "AVP_SECRET"
              value = "avp-{{cluster}}"
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
          #          {
          #            cluster = argocd_cluster.prod.name
          #            url     = argocd_cluster.prod.server
          #          }
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
              name = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name = "AVP_SECRET"
              value = "avp-{{cluster}}"
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

resource "argocd_application_set" "consul" {
  metadata {
    name = "consul"
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
        name = "consul-{{cluster}}"
        labels = {
          cluster = "{{cluster}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name
        source {
          helm {
            release_name = "consul"
            value_files = [
              "$values/consul/{{cluster}}/values.yaml"
            ]
          }
          repo_url        = argocd_repository.hashicorp.repo
          target_revision = "1.x.x"
          chart           = "consul"
        }
        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          ref             = "values"
        }

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "consul/{{cluster}}"
          kustomize {
            common_annotations = {
              "app.kubernetes.io/instance" = "consul"
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
            version = "20.x.x"
          },
          {
            cluster = argocd_cluster.prod.name
            url     = argocd_cluster.prod.server
            version = "23.x.x"
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
          helm {
            release_name = "kafka"
            value_files = [
              "$values/kafka/{{cluster}}/values.yaml"
            ]
          }
          repo_url        = argocd_repository.bitnami.repo
          target_revision = "{{version}}"
          chart           = "kafka"
        }
        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          ref             = "values"
        }

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "kafka/{{cluster}}"
          kustomize {
            common_annotations = {
              "app.kubernetes.io/instance" = "kafka"
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