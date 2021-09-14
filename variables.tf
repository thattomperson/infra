variable "linode_token" {
  description = "Linode Token"
}

variable "cluster_name" {
  description = "The name of the Consul cluster (e.g. consul-stage). This variable is used to namespace all resources created by this module."
  type        = string
  default     = "tf-nomad-consul"
}

variable "image_id" {
  description = "The ID of the Linode Image to run in this cluster. Should be an disk image that had Consul installed and configured by the install-consul module."
  type        = string
  default     = "private/13812551"
}

# TODO: multi-region support
variable "region" {
  description = "The region into which the Linode instances should be deployed."
  type        = string
  default     = "ap-southeast"
}

variable "ssh_keys" {
  description = "A list of SSH Key Pairs that can be used to SSH to the Linode instances in this cluster. Set to an empty list to not associate any Key Pairs."
  type        = list(string)
  default     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMh8dXe/J5O97vJ/oTjZsDHkMmpbWDzFy0a3oQVJ4Ilq thomas.albrighton@four.io"]
}

variable "num_servers" {
  description = "The number of Consul server nodes to deploy. We strongly recommend using 3 or 5."
  type        = number
  default     = 2
}

variable "num_clients" {
  description = "The number of Consul client nodes to deploy. You typically run the Consul client alongside your apps, so set this value to however many Instances make sense for your app code."
  type        = number
  default     = 2
}

variable "cluster_tag_name" {
  description = "Add a tag with this name to each instance. This can be used to automatically find other Consul nodes and form a cluster."
  type        = string
  default     = "tf-nomad-consul-autojoin"
}

variable "tags" {
  description = "List of extra tag blocks added to the Linode instances in the cluster."
  type        = list(string)
  default     = []
}

variable "secure_inboud_ipv4_cidr" {
  type    = string
  default = "0.0.0.0/32"
}

variable "domain" {
  type = string
}

variable "email_address" {
  type = string
}