# Configure the Nomad provider
provider "nomad" {
  address = "http://${module.nomad_servers.instance_ips[0]}:4646"
}

// resource "nomad_job" "fabio" {
//   jobspec = file("./projects/fabio.nomad")
// }

resource "nomad_job" "gw2-adl-cafe" {
  jobspec = file("./projects/gw2.adl.cafe.nomad")
}
