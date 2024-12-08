job "nomad-autoscaler" {
  datacenters = ["kbtu"]

  group "autoscaler" {
   
    volume "local" {
   	type = "host"
	read_only = false
	source = "autoscale"
   } 

     task "autoscaler" {
      driver = "docker"

      volume_mount {
        volume = "local"
        destination = "/config"
        read_only = false
	}

      config {
        image = "hashicorp/nomad-autoscaler:0.4.5"
        args  = ["nomad-autoscaler", "agent", "-config", "/config"]
      }

      resources {
        cpu    = 500 # in MHz
        memory = 256 # in MB
      }
    }
  }
}

