#!/bin/bash

WATCHDIR="/home/logs/"
username=$1
usergroup=$2
NEWFILESNAME=.newfiles$(basename "$WATCHDIR")

if [ ! -f "$WATCHDIR"/.oldfiles ]
then
  ls -A "$WATCHDIR" > "$WATCHDIR"/.oldfiles
fi

ls -A "$WATCHDIR" > $NEWFILESNAME

DIRDIFF=$(diff "$WATCHDIR"/.oldfiles $NEWFILESNAME | cut -f 2 -d "")

for file in $DIRDIFF
do
  if [ -e "$WATCHDIR"/$file ]; then
      sudo chown $username:$usergroup "$WATCHDIR"/$file
      sudo chmod 660 "$WATCHDIR"/$file
  fi
done

rm $NEWFILESNAME