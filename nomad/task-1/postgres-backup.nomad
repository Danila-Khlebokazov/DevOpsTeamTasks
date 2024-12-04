job "postgres_backup" {
  datacenters = ["kbtu"]
  type = "batch"

  periodic {
      cron = "@daily"
      prohibit_overlap = true
    }
  
  task "postgresql-backup" {
    driver = "raw_exec"
    config {
      command = "/bin/bash"
      args = [
        "-c",
        <<EOT
container_id=$(docker ps --filter "name=postgresql" --format "{{.ID}}");
if [ -n "$container_id" ]; then
  docker exec "$container_id" sh -c \
    "PGPASSWORD=$POSTGRES_PASSWORD pg_dump -U postgres -d $POSTGRES_DB" > $BACKUP_DIR/backup_$(date +%Y%m%d%H%M%S).sql;
else
  echo "PostgreSQL container not found";
fi;
EOT
      ]
    }

    env {
      POSTGRES_PASSWORD = "devopsina"
      POSTGRES_DB       = "mydb"
      BACKUP_DIR = "<fill-it>"
    }
  }
}

