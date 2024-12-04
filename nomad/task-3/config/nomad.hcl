data_dir  = "/Users/danilhlebokazov/Documents/Personal/KBTU/DevOpsI/nomad-data"
bind_addr = "0.0.0.0"
server {
  enabled          = true
  bootstrap_expect = 1
}
log_level  = "DEBUG"
datacenter = "kbtu"

client {
  enabled = true
  servers = ["127.0.0.1:4647"]
}

plugin "docker" {}
