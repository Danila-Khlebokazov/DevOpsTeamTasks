#! /bin/bash

# vipe journal structure
# image_sha last_used

get_current_use_images() {
  containers=$(docker container ls -a --format="{{.Image}}" | sed 's/\(^[^:]*$\)/\1:latest/')
  if [ -z "$containers" ]; then
    export containers
  else
    export containers=$(echo $containers | xargs -n1 docker images -q)
  fi
}

viper() {
  if [ ! -f "$VIPE_JOURNAL" ]; then
    touch "$VIPE_JOURNAL"
  fi
  if [ ! -f "$VIPE_LOG" ]; then
    touch "$VIPE_LOG"
  fi

  current_images=$(docker images -q)
  current_use_images=$(get_current_use_images)

  # Update info in journal
  for image in $current_images; do
    last_used=$(date +%s)
    if grep -q $image "$VIPE_JOURNAL"; then
      if echo "$current_use_images" | grep -q $image; then
        sed -i "s/$image.*/$image $last_used/" "$VIPE_JOURNAL"
      elif [ $(($last_used - $(grep $image "$VIPE_JOURNAL" | awk '{print $2}'))) -gt $VIPE_TIME ]; then
        docker rmi $image
        sed -i "/$image/d" "$VIPE_JOURNAL"
        echo "Viper viped image $image at $(date)"
        curl -s -X POST https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage -d chat_id="$CHAT_ID" -d text="Viper viped image $image at $(date)"
      fi
    else
      echo "$image $last_used" >> "$VIPE_JOURNAL"
    fi
  done
}

viper >> "$VIPE_LOG" 2>&1
