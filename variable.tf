variable "ARGOCD_SERVER" {
  type = string
}

variable "ARGOCD_PASSWORD" {
  type = string
}


variable "repo_url" {
  type    = string
  default = "https://github.com/NaturalSelectionLabs/Hephaestus"
}

variable "PAT" {
  type = string
}

variable "GITHUB_APP_ID" {
  type = string
}

variable "GITHUB_APP_PRIVATE_KEY_BASE64" {
  type = string
}

variable "OVH_CA_DATA" {
  type = string
}
