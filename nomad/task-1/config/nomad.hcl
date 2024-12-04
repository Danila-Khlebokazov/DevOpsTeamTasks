data_dir = "<fill-it>"
bind_addr = "0.0.0.0"
server {
	enabled = true
	bootstrap_expect = 1
}
log_level = "DEBUG"
datacenter = "kbtu"

client {
	enabled = true
	servers = ["127.0.0.1:4647"]
	host_volume "postgres" {
		path = "<fill-it>"
		read_only = false
	}
        
  host_volume "backupData" {
    path = "<fill-it>"
    read_only = false
  }
}

plugin "raw_exec" {
	config {
		enabled = true
	}
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}
