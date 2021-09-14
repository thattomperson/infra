job "fabio" {
  datacenters = ["ap-southeast"]
  type = "system"

  group "fabio" {
    network {
      port "lb" {
        static = f
      }
      port "ui" {
        static = 9998
      }
    }
    task "fabio" {
      driver = "docker"
      config {
        image = "fabiolb/fabio"
        network_mode = "host"
        ports = ["lb","ui"]
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}
