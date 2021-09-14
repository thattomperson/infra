job "traefik" {
  region      = "global"
  datacenters = ["ap-southeast"]
  type        = "service"

  group "traefik" {
    count = 1

    network {
      port "http" {
        static = 80
      }

      port "443" {
        static = 443
      }

      port "api" {
        static = 8081
      }
    }

    service {
      name = "traefik"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:v2.4"
        network_mode = "host"
        args = [
          "--entryPoints.http.address=:80",
          "--entryPoints.http.address=:443",
          "--entryPoints.traefik.address=:8081",


          "--api.dashboard=true",
          "--api.insecure=true",
          "--providers.consulcatalog=true",
          "--providers.consulcatalog.exposedByDefault=false",
          "--providers.consulcatalog.endpoint.address=http://127.0.0.1:8500",
          "--providers.consulcatalog.endpoint.scheme=http",
          "--providers.consulcatalog.prefix=traefik",

          "--providers.consulcatalog.defaultrule=Host(`{{ .Name }}.adl.cafe`)",

          "--certificatesresolvers.linode.acme.email=thomasalbrighton@gmail.com",
          "--certificatesresolvers.linode.acme.storage=acme.json",
          "--certificatesresolvers.linode.acme.dnschallenge.provider=linode"
        ]
      }

      env {
        LINODE_TOKEN = "${linode_token}"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
