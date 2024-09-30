#! /bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Please provide the command to run the application"
  echo "Example:"
  echo "$0 'python3 app.py'"
  exit 1
fi

if ! [ -x "$(command -v logrotate)" ]; then
  echo 'Error: logrotate is not installed.' >&2
  sudo apt install logrotate
fi

sudo bash -c "cat <<EOF > /etc/logrotate.d/task4_logs
/home/$2/logs/app.log {
    maxsize 1M
    rotate 3
    su $2 $2
    create
    copytruncate
    postrotate
        echo 'log rotated at $(date)' >> /home/$2/log_rotates.log
    endscript
}
EOF"

if ! sudo grep -Fq "/usr/sbin/logrotate /etc/logrotate.d/task4_logs" /etc/crontab; then
  echo "Adding cron job for logrotate"
  sudo bash -c "echo '* * * * * /usr/sbin/logrotate /etc/logrotate.d/task4_logs' >> /etc/crontab"
  sudo systemctl restart cron
else
  echo "Cron job already exists"
fi

$1 > /home/$2/logs/app.log 2>&1
