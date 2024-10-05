#! /bin/bash

sudo addgroup task5group
sudo useradd -G task5group task5user

app_folder=$1
command_start=$2

sudo cp -r  "$app_folder" /app
sudo chown -R task5user:task5group /app

sudo bash -c "cat <<EOF > /etc/systemd/system/task5.service
[Unit]
Description=Task5 Auto Start
After=network.target

[Service]
ExecStart=$command_start
Restart=always
User=task5user
Group=task5group
WorkingDirectory=/
StandardOutput=append:/app/task5.log
StandardError=append:/app/task5.log


[Install]
WantedBy=multi-user.target
EOF"

sudo systemctl daemon-reload
sudo systemctl start task5.service

sudo systemctl enable task5.service

sudo systemctl status task5.service
