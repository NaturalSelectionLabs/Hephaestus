locals {
  githubOrg = {
    "NaturalSelectionLabs" = "53140922",
    "Crossbell-Box"        = "53140935",
    "RSS3-Network"         = "53140941",
    "RSSNext"              = "53140947",
    "webisopen"            = "56516542",
  }
}

resource "argocd_repository_credentials" "org" {
  for_each = local.githubOrg
  url      = "https://github.com/${each.key}"
  username = "git"

  githubapp_id              = var.GITHUB_APP_ID
  githubapp_installation_id = each.value
  githubapp_private_key     = base64decode(var.GITHUB_APP_PRIVATE_KEY_BASE64)
}