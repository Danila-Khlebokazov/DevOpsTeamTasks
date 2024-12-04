job "deploy_with_dynamic_ports" {
  datacenters = ["kbtu"]
  type        = "service"
  group "deploy" {
    network {
      port "http" {}
    }

    task "deploy" {
      driver = "docker"
      config {
        image = "danilakhlebokazov/task-2-nomad:local"
        ports = ["http"]
        network_mode = "bridge"
      }

      env {
        PORT = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = 1000
        memory = 128
      }

      service {
        provider = "nomad"
        name = "task-2-nomad"
        port = "http"

        check {
          type     = "http"
          path     = "/health"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}