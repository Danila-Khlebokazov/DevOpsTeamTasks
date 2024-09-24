#! /bin/bash

top_n=$1

if [ -z "$top_n" ]; then
  top_n=5
fi

find "/home/$USER" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n $top_n