#! /bin/bash
#if [ -z $1 ];then
#  echo "Provide command to start"
#  exit
#fi

#command_start=$1

sudo cp -r ./file_monitoring.sh /home/file_monitoring.sh
sudo chmod +x /home/file_monitoring.sh

sudo tee /etc/systemd/system/rw_permissions.timer > /dev/null <<EOT
[Unit]
Description=Timer for rw_permissions
Requires=rw_permissions.service

[Timer]
OnCalendar= *-*-* *:*:05
Unit=rw_permissions.service

[Install]
WantedBy=timers.target
EOT



sudo tee /etc/systemd/system/rw_permissions.service > /dev/null <<EOT
[Unit]
Description=Default RW permissions newly created files
After=network.target

[Service]
ExecStart=/bin/bash /home/file_monitoring.sh
Restart=5s
User=root
Group=root
WorkingDirectory=/home



[Install]
WantedBy=multi-user.target
EOT

sudo systemctl daemon-reload
sudo systemctl enable rw_permissions.timer
sudo systemctl start rw_permissions.timer

sudo systemctl status rw_permissions.timer
sudo systemctl status rw_permissions.service
