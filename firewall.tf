
resource "linode_firewall" "nomad_client_firewall" {
  label = "nomad_client_firewall"
  tags  = var.tags

  inbound {
    label    = "allow-inbound-nomad"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "4646"
    ipv4     = ["192.168.128.0/17", var.secure_inboud_ipv4_cidr]
  }

  inbound {
    label    = "allow-inbound-consul"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "8500"
    ipv4     = ["192.168.128.0/17", var.secure_inboud_ipv4_cidr]
  }

  inbound {
    label    = "allow-inbound-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
    ipv4     = ["192.168.128.0/17", var.secure_inboud_ipv4_cidr]
  }

  inbound {
    label    = "allow-inbound-traefik"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "8081"
    ipv4     = ["192.168.128.0/17", var.secure_inboud_ipv4_cidr]
  }

  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = [var.secure_inboud_ipv4_cidr]
  }

  inbound_policy = "DROP"
  outbound_policy = "ACCEPT"

  linodes = concat(module.nomad_clients.instance_ids, module.nomad_servers.instance_ids)
}