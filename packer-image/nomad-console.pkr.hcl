packer {
  required_version = ">= 0.12.0"
  required_plugins {
    linode = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/linode"
    }
  }
}

variable "consul_version" {
  type    = string
  default = "1.10.2"
}

variable "linode_region" {
  type    = string
  default = "ap-southeast"
}

variable "nomad_version" {
  type    = string
  default = "1.1.4"
}

variable "linode_token" {
  type    = string
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "linode" "debian11-image" {
  image             = "linode/debian11"
  image_description = "An example of how to build an Debian 10 (Buster) image that has Nomad and Consul installed"
  image_label       = "debian11-${local.timestamp}"
  instance_label    = "debian11-${local.timestamp}"
  instance_type     = "g6-nanode-1"
  region            = var.linode_region
  linode_token      = var.linode_token
  ssh_username      = "root"
  swap_size         = 256
}

build {
  sources = ["source.linode.debian11-image"]

  provisioner "shell" {
    environment_vars = ["NOMAD_VERSION=${var.nomad_version}", "CONSUL_VERSION=${var.consul_version}"]
    scripts          = [
      "${path.root}/scripts/install-nomad.sh",
      "${path.root}/scripts/install-consul.sh",
      "${path.root}/scripts/install-docker.sh",
    ]
  }

  provisioner "file" {
    source = "${path.root}/scripts/run-nomad"
    destination = "/opt/nomad/bin/run-nomad"
  }

  provisioner "file" {
    source = "${path.root}/scripts/run-consul"
    destination = "/opt/consul/bin/run-consul"
  }

  provisioner "shell" {
    inline = [
      "chown nomad:nomad /opt/nomad/bin/run-nomad",
      "chmod a+x /opt/nomad/bin/run-nomad",
      "chown consul:consul /opt/consul/bin/run-consul",
      "chmod a+x /opt/consul/bin/run-consul"
    ]
  }
}
