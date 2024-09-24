#! /bin/bash

file_path="$1"
new_job_name="$2"

if [ -z "$file_path" ] || [ -z "$new_job_name" ]; then
  echo "Usage: $0 <file_path> <new_job_name>"
  exit 1
fi

sed -i "s/job \".*\"/job \"$new_job_name\"/" $file_path
echo "Job name changed to $new_job_name in $file_path"
