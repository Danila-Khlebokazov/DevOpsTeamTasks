#! /bin/bash
if [ -z $1 ];then
  echo "Provide command to start"
  exit
fi

command_start=$1

sudo tee /etc/systemd/system/rw_permissions.timer > /dev/null <<EOT
[Unit]
Description=Timer for rw_permissions
Requires=rw_permissions.service

[Timer]
OnCalendar= *-*-* *:*:05
Unit=rw_permissions.service
WorkingDirectory=/

[Install]
WantedBy=timers.target
EOT



sudo tee /etc/systemd/system/rw_permissions.service > /dev/null <<EOT
[Unit]
Description=Default RW permissions newly created files
After=network.target

[Service]
ExecStart=$command_start
Restart=5s
User=root
Group=root
WorkingDirectory=/



[Install]
WantedBy=multi-user.target
EOT

sudo systemctl daemon-reload
sudo systemctl enable rw_permissions.timer
sudo systemctl start rw_permissions.timer

sudo systemctl status rw_permissions.timer
sudo systemctl status rw_permissions.service
