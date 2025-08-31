resource "argocd_application_set" "traefik" {
  metadata {
    name = "traefik"
  }
  spec {
    go_template = true
    generator {
      clusters {
        selector {
          match_labels = {
            "argocd.argoproj.io/secret-type" = "cluster"
          }
          match_expressions {
            key      = "provider"
            operator = "NotIn"
            values   = ["alicloud"]
          }
        }
      }
    }
    template {
      metadata {
        name = "traefik-{{.name}}"
        labels = {
          cluster = "{{.name}}"
          env     = "{{.metadata.labels.env}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "traefik/{{.name}}"
          kustomize {
            common_annotations = {
              "github.com/url" = var.repo_url
            }
          }
        }

        destination {
          name      = "{{.name}}"
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
    go_template = true
    generator {
      clusters {
        selector {
          match_labels = {
            "argocd.argoproj.io/secret-type" = "cluster"
          }
        }
      }
    }
    template {
      metadata {
        name = "victoriametrics-{{.name}}"
        labels = {
          cluster = "{{.name}}"
          env     = "{{.metadata.labels.env}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "victoriametrics/{{.name}}"
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
          name      = "{{.name}}"
          namespace = "guardian"
        }

        sync_policy {
          sync_options = ["ServerSideApply=true"]
        }
      }
    }
  }
}

# resource "argocd_application_set" "actions_runner_controller" {
#   metadata {
#     name      = "actions-runner-controller"
#     namespace = "argo"
#   }
#   spec {
#     go_template = true
#     generator {
#       clusters {
#         selector {
#           match_labels = {
#             "argocd.argoproj.io/secret-type" = "cluster"
#             "cluster-type"                   = "gke-standard"
#           }
#         }
#       }
#     }
#     template {
#       metadata {
#         name = "actions-runner-controller-{{.name}}"
#         labels = {
#           cluster = "{{.name}}"
#           env     = "{{.metadata.labels.env}}"
#         }
#       }

#       spec {
#         project = argocd_project.guardian.metadata[0].name
#         source {
#           repo_url        = var.repo_url
#           target_revision = "HEAD"
#           path            = "actions-runner-controller/{{.name}}"
#           plugin {
#             name = "avp-kustomize"
#             env {
#               name  = "APP_REPO"
#               value = "NaturalSelectionLabs/Hephaestus"
#             }
#             env {
#               name  = "AVP_SECRET"
#               value = "guardian:{{.metadata.labels.secret}}"
#             }
#           }
#         }

#         ignore_difference {
#           group               = "admissionregistration.k8s.io"
#           kind                = "*"
#           jq_path_expressions = [".webhooks[].clientConfig.caBundle"]
#         }

#         destination {
#           name      = "{{.name}}"
#           namespace = "guardian"
#         }

#         sync_policy {
#           sync_options = ["ServerSideApply=true"]
#         }

#       }
#     }
#   }
# }

resource "argocd_application_set" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
  spec {
    go_template = true
    generator {
      clusters {
        selector {
          match_labels = {
            "argocd.argoproj.io/secret-type" = "cluster"
          }
        }
      }
    }
    template {
      metadata {
        name = "cert-manager-{{.name}}"
        labels = {
          cluster = "{{.name}}"
          env     = "{{.metadata.labels.env}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name


        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "cert-manager/base"
          kustomize {
            common_annotations = {
              "github.com/url" = var.repo_url
            }
          }
        }

        destination {
          name      = "{{.name}}"
          namespace = "guardian"
        }

      }
    }
  }
}

# resource "argocd_application_set" "kafka" {
#   metadata {
#     name = "kafka"
#   }
#   spec {
#     generator {
#       list {
#         elements = [
#           {
#             cluster = argocd_cluster.dev.name
#             url     = argocd_cluster.dev.server
#           },
#           {
#             cluster = argocd_cluster.prod.name
#             url     = argocd_cluster.prod.server
#           }
#         ]
#       }
#     }
#     template {
#       metadata {
#         name = "kafka-{{cluster}}"
#         labels = {
#           cluster = "{{cluster}}"
#         }
#       }

#       spec {
#         project = argocd_project.guardian.metadata[0].name

#         source {
#           repo_url        = var.repo_url
#           target_revision = "HEAD"
#           path            = "kafka/{{cluster}}"
#           plugin {
#             name = "avp-kustomize"
#             env {
#               name  = "APP_REPO"
#               value = "NaturalSelectionLabs/Hephaestus"
#             }
#             env {
#               name  = "AVP_SECRET"
#               value = "guardian:avp-{{cluster}}"
#             }
#           }
#         }

#         ignore_difference {
#           group = "*"
#           kind  = "Service"
#           jq_path_expressions = [
#             ".spec.ports[].nodePort"
#           ]
#         }

#         destination {
#           server    = "{{url}}"
#           namespace = "guardian"
#         }

#       }
#     }
#   }
# }

# resource "argocd_application_set" "jaeger" {
#   metadata {
#     name = "jaeger"
#   }
#   spec {
#     generator {
#       list {
#         elements = [
#           {
#             cluster = argocd_cluster.dev.name
#             url     = argocd_cluster.dev.server
#           },
#           {
#             cluster = argocd_cluster.prod.name
#             url     = argocd_cluster.prod.server
#           }
#         ]
#       }
#     }
#     template {
#       metadata {
#         name = "jaeger-{{cluster}}"
#         labels = {
#           cluster = "{{cluster}}"
#         }
#       }
#       spec {
#         project = argocd_project.guardian.metadata[0].name

#         source {
#           repo_url        = var.repo_url
#           target_revision = "HEAD"
#           path            = "jaeger/{{cluster}}"
#           plugin {
#             name = "avp-kustomize"
#             env {
#               name  = "APP_REPO"
#               value = "NaturalSelectionLabs/Hephaestus"
#             }
#             env {
#               name  = "AVP_SECRET"
#               value = "guardian:avp-{{cluster}}"
#             }
#           }
#         }

#         destination {
#           server    = "{{url}}"
#           namespace = "guardian"
#         }
#       }
#     }

#   }
# }

resource "argocd_application_set" "exporter" {
  metadata {
    name = "exporter"
  }
  spec {
    go_template = true
    generator {
      clusters {
        selector {
          match_labels = {
            "argocd.argoproj.io/secret-type" = "cluster"
          }
        }
      }
    }
    template {
      metadata {
        name = "exporter-{{.name}}"
        labels = {
          cluster = "{{.name}}"
          env     = "{{.metadata.labels.env}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name
        source {
          repo_url        = "https://github.com/NaturalSelectionLabs/Cluster-Exporter"
          target_revision = "HEAD"
          path            = "exporters/{{.name}}"
          plugin {
            name = "avp-kustomize"
            env {
              name  = "APP_REPO"
              value = "NaturalSelectionLabs/Hephaestus"
            }
            env {
              name  = "AVP_SECRET"
              value = "guardian:{{.metadata.labels.secret}}"
            }
          }
        }

        destination {
          name      = "{{.name}}"
          namespace = "guardian"
        }

        sync_policy {
          sync_options = ["ServerSideApply=true"]
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

# resource "argocd_application_set" "etcd" {
#   metadata {
#     name = "etcd"
#   }
#   spec {
#     generator {
#       list {
#         elements = [
#           {
#             cluster = argocd_cluster.dev.name
#             url     = argocd_cluster.dev.server
#           },
#           #          {
#           #            cluster = argocd_cluster.prod.name
#           #            url     = argocd_cluster.prod.server
#           #          }
#         ]
#       }
#     }
#     template {
#       metadata {
#         name = "etcd-{{cluster}}"
#         labels = {
#           cluster = "{{cluster}}"
#         }
#       }
#       spec {
#         project = argocd_project.guardian.metadata[0].name

#         source {
#           repo_url        = var.repo_url
#           target_revision = "HEAD"
#           path            = "etcd/{{cluster}}"
#           plugin {
#             name = "avp-kustomize"
#             env {
#               name  = "APP_REPO"
#               value = "NaturalSelectionLabs/Hephaestus"
#             }
#             env {
#               name  = "AVP_SECRET"
#               value = "guardian:avp-{{cluster}}"
#             }
#           }
#         }

#         destination {
#           server    = "{{url}}"
#           namespace = "guardian"
#         }
#       }
#     }
#   }
# }

# resource "argocd_application_set" "argo-workflow" {
#   metadata {
#     name = "argo-workflow"
#   }
#   spec {
#     generator {
#       list {
#         elements = [
#           {
#             cluster = argocd_cluster.dev.name
#             url     = argocd_cluster.dev.server
#           },
#           {
#             cluster = argocd_cluster.prod.name
#             url     = argocd_cluster.prod.server
#           }
#         ]
#       }
#     }
#     template {
#       metadata {
#         name = "argo-workflow-{{cluster}}"
#       }

#       spec {
#         project = argocd_project.guardian.metadata[0].name

#         source {
#           repo_url        = var.repo_url
#           target_revision = "HEAD"
#           path            = "argo-workflow/{{cluster}}"
#           plugin {
#             name = "avp-kustomize"
#             env {
#               name  = "APP_REPO"
#               value = "NaturalSelectionLabs/Hephaestus"
#             }
#             env {
#               name  = "AVP_SECRET"
#               value = "guardian:avp-{{cluster}}"
#             }
#           }
#         }

#         destination {
#           server    = "{{url}}"
#           namespace = "guardian"
#         }
#       }
#     }
#   }
# }

resource "argocd_application_set" "promtail" {
  metadata {
    name = "promtail"
  }
  spec {
    go_template = true
    generator {
      clusters {
        selector {
          match_labels = {
            "argocd.argoproj.io/secret-type" = "cluster"
          }
        }
      }
    }
    template {
      metadata {
        name = "promtail-{{.name}}"
        labels = {
          cluster = "{{.name}}"
          env     = "{{.metadata.labels.env}}"
        }
      }
      spec {
        project = argocd_project.guardian.metadata[0].name
        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "promtail/{{.name}}"
          kustomize {
            common_annotations = {
              "github.com/url" = var.repo_url
            }
          }
        }

        destination {
          name      = "{{.name}}"
          namespace = "guardian"
        }
      }
    }

  }
}

resource "argocd_application_set" "keda" {
  metadata {
    name = "keda"
  }
  spec {
    go_template = true
    generator {
      clusters {
        selector {
          match_labels = {
            "argocd.argoproj.io/secret-type" = "cluster"
          }
        }
      }
    }
    template {
      metadata {
        name = "keda-{{.name}}"
        labels = {
          cluster = "{{.name}}"
          env     = "{{.metadata.labels.env}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "keda/base"
          kustomize {
            common_annotations = {
              "github.com/url" = var.repo_url
            }
          }
        }

        destination {
          name      = "{{.name}}"
          namespace = "guardian"
        }
      }
    }
  }
}

resource "argocd_application_set" "cloud_native_pg" {
  metadata {
    name = "cloud-native-pg"
  }
  spec {
    go_template = true
    generator {
      clusters {
        selector {
          match_labels = {
            "argocd.argoproj.io/secret-type" = "cluster"
            "cluster-type"                   = "rke2"
          }
        }
      }
    }
    template {
      metadata {
        name = "cloud-native-pg-{{.name}}"
        labels = {
          cluster = "{{.name}}"
          env     = "{{.metadata.labels.env}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "cloud-native-pg"
          kustomize {
            common_annotations = {
              "github.com/url" = var.repo_url
            }
          }
        }

        destination {
          name      = "{{.name}}"
          namespace = "guardian"
        }
      }
    }
  }
}

resource "argocd_application_set" "longhorn" {
  metadata {
    name = "longhorn"
  }
  spec {
    go_template = true
    generator {
      clusters {
        selector {
          match_labels = {
            "argocd.argoproj.io/secret-type" = "cluster"
            "provider"                       = "ovh"
            "cluster-type"                   = "rke2"
          }
        }
      }
    }
    template {
      metadata {
        name = "longhorn-{{.name}}"
        labels = {
          cluster = "{{.name}}"
          env     = "{{.metadata.labels.env}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "longhorn/{{.name}}"
          kustomize {
            common_annotations = {
              "github.com/url" = var.repo_url
            }
          }
        }

        destination {
          name      = "{{.name}}"
          namespace = "longhorn-system"
        }
      }
    }
  }
}


resource "argocd_application_set" "knative" {
  metadata {
    name = "knative"
  }
  spec {
    go_template = true
    generator {
      clusters {
        selector {
          match_labels = {
            "argocd.argoproj.io/secret-type" = "cluster"
            "provider"                       = "ovh"
            "cluster-type"                   = "rke2"
          }
        }
      }
    }
    template {
      metadata {
        name = "knative-{{.name}}"
        labels = {
          cluster = "{{.name}}"
          env     = "{{.metadata.labels.env}}"
        }
      }

      spec {
        project = argocd_project.guardian.metadata[0].name

        source {
          repo_url        = var.repo_url
          target_revision = "HEAD"
          path            = "knative/{{.name}}"
          kustomize {
            common_annotations = {
              "github.com/url" = var.repo_url
            }
          }
        }

        // rbac.authorization.k8s.io/ClusterRole/knative-serving-operator-aggregated-stable
        // .rules
        ignore_difference {
          group = "rbac.authorization.k8s.io"
          kind  = "ClusterRole"
          name  = "knative-serving-operator-aggregated-stable"
          jq_path_expressions = [
            ".rules"
          ]
        }

        // ignore namespace knative-serving labels and annotations
        ignore_difference {
          group = "*"
          kind  = "Namespace"
          name  = "knative-serving"

          jq_path_expressions = [".metadata.labels", ".metadata.annotations"]
        }

        destination {
          name      = "{{.name}}"
          namespace = "knative-operator"
        }
      }
    }
  }
}
