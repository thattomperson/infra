terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.20.2"
    }
    acme = {
      source = "vancluever/acme"
      version = "2.5.3"
    }
  }
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

provider "linode" {
  token = var.linode_token
}
