#!/bin/bash

sudo tee /home/file_monitoring.sh > /dev/null <<'EOF'
#!/bin/bash

WATCHDIR="/home/logs/"
username=task5user
usergroup=task5group
NEWFILESNAME=.newfiles$(basename "$WATCHDIR")

if [ ! -f "$WATCHDIR"/.oldfiles ]; then
  ls -A "$WATCHDIR" > "$WATCHDIR"/.oldfiles
fi

ls -A "$WATCHDIR" > $NEWFILESNAME

DIRDIFF=$(diff "$WATCHDIR"/.oldfiles $NEWFILESNAME | grep "^>" | cut -f 2 -d " ")
echo $DIRDIFF

for file in $DIRDIFF; do
  echo $file
  if [ -e "$WATCHDIR"/$file ]; then
      sudo chown $username:$usergroup "$WATCHDIR"/$file
      sudo chmod 660 "$WATCHDIR"/$file
  fi
done

rm $NEWFILESNAME
EOF

sudo chmod +x /home/file_monitoring.sh

sudo tee /etc/systemd/system/rw_permissions.timer > /dev/null <<EOT
[Unit]
Description=Timer for rw_permissions
Requires=rw_permissions.service

[Timer]
OnBootSec=5
OnUnitActiveSec=10
AccuracySec=1
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
