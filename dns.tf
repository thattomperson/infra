
resource "linode_domain" "domain" {
  type      = "master"
  domain    = var.domain
  soa_email = "thomasalbrighton@gmail.com"
}

resource "linode_domain_record" "domain_record_client_star" {
  count       = var.num_clients
  domain_id   = linode_domain.domain.id
  name        = "*"
  record_type = "A"
  target      = element(module.nomad_clients.instance_private_ips, count.index)
}

resource "linode_domain_record" "domain_record_client_apex" {
  count       = var.num_clients
  domain_id   = linode_domain.domain.id
  name        = ""
  record_type = "A"
  target      = element(module.nomad_clients.instance_private_ips, count.index)
}