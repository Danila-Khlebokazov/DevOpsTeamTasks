#!bin/bash
# https://unix.stackexchange.com/questions/68956/block-network-access-of-a-process

if [ -z "$1" ]; then
  echo "Please provide the command to run the application"
  echo "Example:"
  echo "$0 'python3 app.py'"
  exit 1
fi

systemd-run --scope -p IPAddressDeny=any -p IPAddressAllow=localhost $1
