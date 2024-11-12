#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <path>"
  exit 1
fi

COMPOSE_DIR=$1

SERVICES=("docker-compose-main.yml" "docker-compose-node1.yml" "docker-compose-node2.yml" "docker-compose-node3.yml" "docker-compose-node4.yml")

for SERVICE in "${SERVICES[@]}"; do
  SERVICE_NAME=$(basename "$SERVICE" .yml)
  UNIT_FILE="/etc/systemd/system/$SERVICE_NAME.service"

  echo "Creating systemd service file for $SERVICE_NAME at $UNIT_FILE..."

  cat <<EOL | sudo tee "$UNIT_FILE" > /dev/null
[Unit]
Description=$SERVICE_NAME service
Requires=docker.service
After=docker.service

[Service]
WorkingDirectory=$COMPOSE_DIR
ExecStart=/usr/bin/docker-compose -f $SERVICE up -d
ExecStop=/usr/bin/docker-compose -f $SERVICE down
Restart=always
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOL

  sudo systemctl daemon-reload
  sudo systemctl enable "$SERVICE_NAME.service"
done

echo "All systemd service files created and enabled."
