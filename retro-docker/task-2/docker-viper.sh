#! /bin/bash

# vipe journal structure
# image_sha last_used

VIPE_TIME=300
VIPE_JOURNAL=/var/lib/docker-viper/vipe-container.journal
VIPE_LOG=/var/lib/docker-viper/viper.log

viper() {
  if [ ! -f "$VIPE_JOURNAL" ]; then
    touch "$VIPE_JOURNAL"
  fi
  if [ ! -f "$VIPE_LOG" ]; then
    touch "$VIPE_LOG"
  fi

  current_images=$(docker images -q)
  current_use_images=$(docker container ls -a --format="{{.Image}}" | sed 's/\(^[^:]*$\)/\1:latest/' | xargs -n1 docker images -q)

  # Update info in journal
  for image in $current_images; do
    last_used=$(date +%s)
    if grep -q $image "$VIPE_JOURNAL"; then
      if echo "$current_use_images" | grep -q $image; then
        sed -i "s/$image.*/$image $last_used/" "$VIPE_JOURNAL"
      elif [ $(($last_used - $(grep $image /tmp/viper_journal | awk '{print $2}'))) -gt $VIPE_TIME ]; then
        image_info=$(docker images --format="{{.Repository}}:{{.Tag}}" $image)
        docker rmi $image
        sed -i "/$image/d" "$VIPE_JOURNAL"
        echo "Viper viped image $image $image_info at $(date)"
      fi
    else
      echo "$image $last_used" >> "$VIPE_JOURNAL"
    fi
  done
}

viper >> "$VIPE_LOG" 2>&1
