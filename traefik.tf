# Configure the Nomad provider
provider "nomad" {
  address = "http://${module.nomad_servers.instance_ips[0]}:4646"
}

resource "linode_token" "traefik_acme_token" {
  label  = "traefik_acme_token"
  scopes = "domains:read_write"
}

resource "nomad_job" "traefik" {
  jobspec = templatefile("./projects/traefik.nomad", {
    linode_token = linode_token.traefik_acme_token.token
  })
}