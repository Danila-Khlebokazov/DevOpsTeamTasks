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

if ! sudo grep -Fq "/usr/sbin/logrotate /etc/logrotate.d/task4_logs" /etc/crontab; then
  echo "Adding cron job for logrotate"
  sudo bash -c "echo '* * * * * root /usr/sbin/logrotate /etc/logrotate.d/task4_logs' >> /etc/crontab"
  sudo systemctl restart cron
else
  echo "Cron job already exists"
fi

if [ ! -d /home/logs/ ]; then
  mkdir /home/logs/
fi
if [ ! -f /home/logs/app.log ]; then
  touch /home/logs/app.log
fi

$1 >> /home/logs/app.log 2>&1 &
