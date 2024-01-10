resource "argocd_repository_credentials" "nsl" {
  url      = "https://github.com/NaturalSelectionLabs"
  username = "git"
  password = var.PAT
}

resource "argocd_repository_credentials" "crossbell" {
  url      = "https://github.com/Crossbell-Box"
  username = "git"
  password = var.PAT
}

resource "argocd_repository_credentials" "crossbell" {
  url      = "https://github.com/RSS3-Network"
  username = "git"
  password = var.PAT
}