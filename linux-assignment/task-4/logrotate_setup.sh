#! /bin/bash

if [ -z "$1" ]; then
  echo "Please provide the command to run the application"
  echo "Example:"
  echo "$0 'python3 app.py'"
  exit 1
fi

if ! [ -x "$(command -v logrotate)" ]; then
  echo 'Error: logrotate is not installed.' >&2
  sudo apt install logrotate
fi

sudo cat <<EOF > /etc/logrotate.d/task4_logs
/home/logs/app.log {
    maxsize 1M
    rotate 3
    su root root
    create
    copytruncate
    postrotate
        echo "log rotated at \$(date)" >> /home/log_rotates.log
    endscript
}
EOF


if [ ! -f /etc/systemd/system/monitoring.system ]; then
  sudo cat <<EOF > /etc/systemd/system/monitoring.system
[Unit]
Description=Monitoring Service
Wants=logrotate.timer

[Service]
Type=oneshot
WorkingDirectory=/
ExecStart=/usr/sbin/logrotate /etc/logrotate.d/task4_logs

[Install]
WantedBy=multi-user.target
EOF
fi


# create timer for logrotate
if [ ! -f /etc/systemd/system/logrotate.timer ]; then
  sudo cat <<EOF > /etc/systemd/system/logrotate.timer
[Unit]
Description=Second Log Rotation
Requires=monitoring.service

[Timer]
OnCalendar= *-*-* *:*:*
Unit=monitoring.service
WorkingDirectory=/

[Install]
WantedBy=timers.target
EOF
fi

if [ ! -d /home/logs/ ]; then
  mkdir /home/logs/
fi
if [ ! -f /home/logs/app.log ]; then
  touch /home/logs/app.log
fi

$1 >> /home/logs/app.log 2>&1 &

sudo systemctl daemon-reload

sudo systemctl start logrotate.timer
