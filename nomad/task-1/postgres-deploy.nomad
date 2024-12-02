job "postgresql" {
  datacenters = ["kbtu"]
  type = "service"

  group "postgresql" {
    count = 1
    
    network {
      mbits = 10
      port "db" {
        static = 5432
      }
    }
    volume "postgres_data" {
      type      = "host"
      read_only = false 
      source    = "postgres"
    }
    task "postgresql" {
      driver = "docker"
      config {
        image = "postgres:14.15-alpine"
        ports = ["db"] 
        volumes = [
          "postgres_data:/var/lib/postgresql/data" 
        ]
      }

      env {
        POSTGRES_PASSWORD = "devopsina"
        POSTGRES_DB       = "mydb"
      }

      service {
	provider = "nomad"
        name = "postgresql"
        tags = ["db"]
        port = "db" 
      }

      restart {
        attempts = 3
        interval = "10m"
        delay    = "30s" 
        mode     = "delay" 
      }
    }
  }
}

