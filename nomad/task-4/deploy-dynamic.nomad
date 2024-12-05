job "deploy_with_dynamic_ports" {
  datacenters = ["kbtu"]
  type        = "service"

  group "deploy" {
    count = 1

    scaling {
      enabled = true
      min     = 1
      max     = 8

      policy {
        cooldown            = "20s"
        evaluation_interval = "5s"
        check "cpu_allocated_percentage" {
          source       = "nomad-apm"
          query        = "avg_cpu-allocated"
          query_window = "5s"
          strategy "target-value" {
            target = 70
          }
        }
      }
    }

    network {
      port "http" {}
    }

    task "deploy" {
      driver = "docker"
      config {
        image        = "danilakhlebokazov/task-2-nomad:local"
        ports        = ["http"]
        network_mode = "bridge"
      }

      env {
        PORT = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = 100
        memory = 128
      }

      service {
        provider = "nomad"
        name     = "task-2-nomad"
        port     = "http"

        check {
          type     = "http"
          path     = "/health"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }

    update {
      max_parallel     = 1
      min_healthy_time = "10s"
      healthy_deadline = "1m"
      auto_revert      = true
      canary           = 1
    }
  }
}