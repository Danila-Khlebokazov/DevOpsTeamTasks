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

    volume "backup_dir" {
      type      = "host"
      read_only = false
      source    = "backupData"
    }

    task "postgresql" {
      driver = "docker"
     
      volume_mount {
        volume      = "backup_dir"
        destination = "/folder/backup"
        read_only   = false
      }
 
      config {
        image = "postgres:14.15-alpine"
        ports = ["db"] 
	      hostname = "my_postgresql"
        entrypoint = ["/bin/sh", "-c"]
        args = [
          <<EOT
echo "Starting PostgreSQL..."
BACKUP_DIR="/folder/backup";
echo "Backup directory: $BACKUP_DIR";
LATEST_BACKUP=$(ls -t $BACKUP_DIR/backup_*.sql 2>/dev/null | head -n 1);
echo "LATEST: $LATEST_BACKUP";
if [ -n "$LATEST_BACKUP" ]; then
	echo "Restoring from backup: $LATEST_BACKUP...";
	
	PGPASSWORD=$POSTGRES_PASSWORD psql -U postgres -d $POSTGRES_DB < "$LATEST_BACKUP";
	echo "Restore complete.";
else
	echo "No backup found, starting with a clean database.";
fi;
exec docker-entrypoint.sh postgres
EOT
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

