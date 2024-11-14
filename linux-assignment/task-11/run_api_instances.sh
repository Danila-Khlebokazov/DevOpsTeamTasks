#!/bin/bash

N=$1 # number of instances, passed through command line, the first argument /run_api_instances.sh N(for ex.3)
if [ -z $N ]; then
  echo "Please provide the number of instances to run"
  exit 1
fi
BASE_PORT=8080
PROCESS_LIST=() # list of processes their id, to terminate later
CURRENT=0 # used for round robin algorithm
api_server_path=$2
if [ -z $api_server_path ]; then
  echo "Please provide the path to the API server"
  exit 1
fi

# instance initialization
start_instances() {
  echo "starting $N instances of API server..."
  for ((i = 0; i < N; i++)); do
    PORT=$((BASE_PORT+i)) # 8080 + i
    "$api_server_path" "$PORT" &
    PROCESS_LIST+=($!)
    echo "Started server instance $((i+1)) on port $PORT with process id ${PROCESS_LIST[i]}"
  done
}

# handle the incoming requests
handle_request() {
  PORT=$((BASE_PORT + CURRENT))
  echo "Routing health check to instance on port $PORT"

  # getting http response code from curl
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT/health")

  if [ "$RESPONSE" -eq 200 ]; then
    echo "Instance on port $PORT is healthy."
  else
    echo "Instance on port $PORT is unhealthy or not responding."
  fi

  CURRENT=$(( (CURRENT + 1) % N ))
}

# SIGINT(signal interrupted ctrl+C)
stop_instance() {
  echo "Stopping all instances..."
  for PROCESS in "${PROCESS_LIST[@]}"; do
    kill "$PROCESS"
    echo "Stopped instance with process $PROCESS"
  done
}

# signal interrupted call the stop instance function
trap 'stop_instance; exit' SIGINT

# start instances
start_instances

# requests for handling
while true; do
  handle_request
  sleep 1
done