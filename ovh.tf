provider "kubernetes" {
  alias       = "ovh"
  host        = "https://k8s.ovh.naturalselectionlabs.com"
  config_path = "~/.kube/config.ovh"
}

module "ovh-argocd-manager" {
  source = "./modules/argocd-manager"
  providers = {
    kubernetes = kubernetes.ovh
  }
}
