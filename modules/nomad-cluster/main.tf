terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.20.2"
    }
  }
}

resource "linode_token" "bootstrap" {
  scopes = "linodes:read_only"
  label  = "${var.cluster_name}-bootstrap"
  expiry = "2999-12-12T05:00:00Z"
}

resource "linode_instance" "nomad_instance" {
  count = var.cluster_size

  label = "${var.cluster_name}-${count.index}"
  # TODO region-count product
  region = var.region
  type = var.instance_type
  # TODO: clean up role-server magic string
  tags = concat([
    var.cluster_tag_name,
    "${var.cluster_tag_name}-role-${var.role}",
  ], var.tags)
  private_ip = true

  disk {
    label = "boot"
    # TODO: configurable size
    size = 10000
    image  = var.image_id
    filesystem = "ext4"

    authorized_keys = var.ssh_keys
    # TODO: ssh user var
    # authorized_users = [ "${data.linode_profile.me.username}" ]
  }

  disk {
    label = "swap"
    # TODO: configurable size
    size = 256
    filesystem = "swap"
  }

  config {
    label = "config"
    kernel = "linode/grub2"
    devices {
      sda {
        disk_label = "boot"
      }
      sdb {
        disk_label = "swap"
      }
    }
    root_device = "/dev/sda"
  }

  boot_config_label = "config"

  provisioner "file" {
    connection {
      host  = self.ip_address
      type  = "ssh"
      user  = "root"
      agent = "true"
    }

    content     = "[DEFAULT]\n token = ${linode_token.bootstrap.token}\n region=${var.region}\n type=${var.instance_type}\n image=${var.image_id}\n"
    destination = "/root/.linode-cli"
  }

  provisioner "remote-exec" {
    connection {
      host  = self.ip_address
      type  = "ssh"
      user  = "root"
      agent = "true"
    }

    inline = [
      "/opt/consul/bin/run-consul --${var.role} --datacenter ${var.region} --cluster-tag-name ${var.cluster_tag_name} --environment LINODE_TOKEN=${linode_token.bootstrap.token} --environment LINODE_CLI_TOKEN=${linode_token.bootstrap.token}",
      "/opt/nomad/bin/run-nomad --${var.role} %{ if var.role == "server" }--num-servers ${var.cluster_size}%{ endif }"
    ]
  }
}
