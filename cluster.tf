
# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE SERVER NODES
# Note that we use the consul-cluster module to deploy both the Nomad and Consul nodes on the same servers
# ---------------------------------------------------------------------------------------------------------------------

module "nomad_servers" {
  source = "./modules/nomad-cluster"

  role             = "server"
  cluster_name     = "${var.cluster_name}-server"
  cluster_size     = var.num_servers
  cluster_tag_name = var.cluster_tag_name
  image_id         = var.image_id
  instance_type    = "g6-nanode-1"
  region           = var.region
  ssh_keys         = var.ssh_keys
  tags             = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE CLIENT NODES
# ---------------------------------------------------------------------------------------------------------------------

module "nomad_clients" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/hashicorp/terraform-aws-nomad//modules/nomad-cluster?ref=v0.0.1"
  source = "./modules/nomad-cluster"

  role             = "client"
  cluster_name     = "${var.cluster_name}-client"
  cluster_size     = var.num_clients
  cluster_tag_name = var.cluster_tag_name
  image_id         = var.image_id
  instance_type    = "g6-nanode-1"
  region           = var.region
  ssh_keys         = var.ssh_keys
  tags             = var.tags
}

resource "linode_nodebalancer" "nomad_clients" {
  label                = "nomad-clients"
  region               = var.region
  client_conn_throttle = 20
  tags                 = [var.cluster_tag_name]
}

resource "linode_nodebalancer_config" "http" {
  nodebalancer_id = linode_nodebalancer.nomad_clients.id
  port            = 80
  protocol        = "http"
  stickiness      = "none"
  algorithm       = "leastconn"
}

resource "linode_nodebalancer_config" "https" {
  nodebalancer_id = linode_nodebalancer.nomad_clients.id
  port            = 443
  protocol        = "https"
  stickiness      = "none"
  algorithm       = "leastconn"

  ssl_key  = acme_certificate.certificate.private_key_pem
  ssl_cert = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
}

resource "linode_nodebalancer_node" "http" {
  count           = var.num_clients
  label           = "nomad-client-http-${count.index}"
  nodebalancer_id = linode_nodebalancer.nomad_clients.id
  config_id       = linode_nodebalancer_config.http.id
  address         = "${element(module.nomad_clients.instance_private_ips, count.index)}:9999"
}

resource "linode_nodebalancer_node" "https" {
  count           = var.num_clients
  label           = "nomad-client-https-${count.index}"
  nodebalancer_id = linode_nodebalancer.nomad_clients.id
  config_id       = linode_nodebalancer_config.https.id
  address         = "${element(module.nomad_clients.instance_private_ips, count.index)}:9999"
}


resource "linode_domain_record" "nomad_clients_v4_star" {
  domain_id   = linode_domain.domain.id
  name        = "*"
  record_type = "A"
  target      = linode_nodebalancer.nomad_clients.ipv4
}
resource "linode_domain_record" "nomad_clients_v6_star" {
  domain_id   = linode_domain.domain.id
  name        = "*"
  record_type = "AAAA"
  target      = linode_nodebalancer.nomad_clients.ipv6
}

resource "linode_domain_record" "nomad_clients_v4_apex" {
  domain_id   = linode_domain.domain.id
  name        = ""
  record_type = "A"
  target      = linode_nodebalancer.nomad_clients.ipv4
}
resource "linode_domain_record" "nomad_clients_6_apex" {
  domain_id   = linode_domain.domain.id
  name        = ""
  record_type = "AAAA"
  target      = linode_nodebalancer.nomad_clients.ipv6
}