
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
