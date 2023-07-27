resource "helm_release" "traefik" {
  repository = "https://helm.traefik.io/traefik"
  chart = "traefik"
  name  = "traefik"

  values = [
    file("../traefik/dev/values.yaml")
  ]
}