
resource "linode_domain" "domain" {
  type      = "master"
  domain    = var.domain
  soa_email = "thomasalbrighton@gmail.com"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email_address
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]

  dns_challenge {
    provider = "linode"

    config = {
      LINODE_TOKEN = var.linode_token
    }
  }
}