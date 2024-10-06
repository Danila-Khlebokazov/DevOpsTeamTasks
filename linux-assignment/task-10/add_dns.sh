#! /bin/bash

# https://stackoverflow.com/questions/19339248/append-line-to-etc-hosts-file-with-shell-script

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Please write ip_address and domain"
  echo "Example:"
  echo "$0 '127.0.0.1 example'"
  exit 1
fi

echo "$1 $2" >>/etc/hosts
