# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name of the Consul cluster (e.g. consul-stage). This variable is used to namespace all resources created by this module."
  type        = string
}

variable "image_id" {
  description = "The ID of the Linode Image to run in this cluster. Should be an AMI that had Consul installed and configured by the install-consul module."
  type        = string
}

variable "instance_type" {
  description = "The type of Linode type to run for each node in the cluster (e.g. g6-standard-1)."
  type        = string
}

# TODO: multi-region support
variable "region" {
  description = "The region into which the Linode instances should be deployed."
  type        = string
}

variable "role" {
  description = "The role must be one of \"server\" or \"client\"."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

#
variable "cluster_size" {
  description = "The number of nodes to have in the Consul cluster. We strongly recommended that you use either 3 or 5."
  type        = number
  default     = 3
}


variable "cluster_tag_name" {
  description = "Add a tag with this name to each instance. This can be used to automatically find other Consul nodes and form a cluster."
  type        = string
  default     = "nomad-consul-servers-auto-join"
}

variable "ssh_keys" {
  description = "A list of SSH Key Pairs that can be used to SSH to the Linode instances in this cluster. Set to an empty list to not associate any Key Pairs."
  type        = list(string)
  default     = []
}

# TODO: disk sizes
variable "root_volume_size" {
  description = "The size, in GB, of the root volume."
  type        = number
  default     = 50
}

# TODO: firewall
variable "server_rpc_port" {
  description = "The port used by servers to handle incoming requests from other agents."
  type        = number
  default     = 8300
}

variable "cli_rpc_port" {
  description = "The port used by all agents to handle RPC from the CLI."
  type        = number
  default     = 8400
}

variable "serf_lan_port" {
  description = "The port used to handle gossip in the LAN. Required by all agents."
  type        = number
  default     = 8301
}

variable "serf_wan_port" {
  description = "The port used by servers to gossip over the WAN to other servers."
  type        = number
  default     = 8302
}

variable "http_api_port" {
  description = "The port used by clients to talk to the HTTP API"
  type        = number
  default     = 8500
}

variable "dns_port" {
  description = "The port used to resolve DNS queries."
  type        = number
  default     = 8600
}

variable "ssh_port" {
  description = "The port used for SSH connections"
  type        = number
  default     = 22
}

variable "tags" {
  description = "List of extra tag blocks added to the Linode instances in the cluster."
  type        = list(string)
  default     = []
}