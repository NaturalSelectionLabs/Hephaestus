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