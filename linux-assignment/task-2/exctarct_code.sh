#! /bin/bash

curr=$(pwd)
curr_dir=$(echo "${PWD##*/}")


while [ -n "$(ls *.zip)" ]; do
    file=$(ls *.zip | head -n 1)
    unzip -od $(echo $file | cut -d'.' -f1 ) $file
    cd $(echo $file | sed 's/.zip//')
    if [ -n "$(ls -I*.zip -Iempty.txt)" ]; then
      echo "Extracting $(ls -I*.zip -Iempty.txt)"
      echo "File content: $(cat $(ls -I*.zip -Iempty.txt))"
      echo "\n21B030946, 21B030574" >> $(ls -I*.zip -Iempty.txt)
      cp $(ls -I*.zip -Iempty.txt) $curr/word.txt
    fi
done

read  -n 1 -p "Ready to pack back?)" _

while [ $(echo "${PWD##*/}") != curr_dir ]; do
  dir=$(echo "${PWD##*/}")
  zip -r ../"$dir"_new.zip *
  cd ..
  rm -rf $dir
done