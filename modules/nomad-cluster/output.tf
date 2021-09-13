output "instance_ids" {
  value = linode_instance.nomad_instance.*.id
}

output "instance_ips" {
  value = linode_instance.nomad_instance.*.ip_address
}

output "instance_private_ips" {
  value = linode_instance.nomad_instance.*.private_ip_address
}