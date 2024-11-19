#!/bin/bash

# Configurations
BROKER_CONFIGS=("broker01.properties" "broker02.properties" "broker03.properties")
BROKER_PORTS=("9092" "9093" "9094")
TOPICS=("topic1" "topic2")
KAFKA_HOME="/mnt/c/kafka/kafka_2.12-3.9.0"  # Adjust to your Kafka installation directory
KAFKA_PRODUCER_CMD="$KAFKA_HOME/bin/kafka-console-producer.sh"

# Function to stop a broker using kafka-server-stop.sh
stop_broker() {
    local port=$1
    echo "Stopping broker on port $port..."

    # Use kafka-server-stop.sh to stop the broker
    "$KAFKA_HOME/bin/kafka-server-stop.sh"

    # Give time for broker to stop gracefully
    sleep 5

    # Verify if broker is stopped
    local pid=$(lsof -i :$port -t)
    if [[ -z $pid ]]; then
        echo "Broker on port $port has been stopped."
    else
        echo "Failed to stop broker on port $port."
    fi
}

# Function to start a broker
start_broker() {
    local config_file=$1
    echo "Starting broker with config: $config_file"
    "$KAFKA_HOME/bin/kafka-server-start.sh" "$KAFKA_HOME/config/$config_file" > /dev/null 2>&1 &
    sleep 5  # Allow the broker time to start
    echo "Broker started with config: $config_file"
}

# Function to send messages to topics
send_messages() {
    echo "Sending messages to topics..."

    local random_port=$1
    local active_brokers=""

    # Build the active broker list, excluding the stopped broker
    for port in "${BROKER_PORTS[@]}"; do
        if [[ "$port" != "$random_port" ]]; then
            if [[ -z "$active_brokers" ]]; then
                active_brokers="localhost:$port"
                break
            else
                active_brokers="$active_brokers,localhost:$port"
            fi
        fi
    done

    echo "Active brokers: $active_brokers"

    # # Send messages to each topic
    # for topic in "${TOPICS[@]}"; do
    #     echo "Message to $topic at $(date)" | $KAFKA_PRODUCER_CMD --broker-list "$active_brokers" --topic "$topic"
    #     if [[ $? -ne 0 ]]; then
    #         echo "Failed to send message to topic $topic using brokers: $active_brokers"
    #     else
    #         echo "Message sent to topic $topic successfully."
    #     fi
    # done
    echo "Finished sending messages."
}


# Main loop to periodically stop brokers and send messages
while true; do
    # Stop all brokers
    for port in "${BROKER_PORTS[@]}"; do
        stop_broker "$port"
    done

    # Start all but one broker randomly
    index=$((RANDOM % ${#BROKER_PORTS[@]}))
    random_port=${BROKER_PORTS[$index]}
    echo "Randomly stopping broker on port: $random_port"

    for i in "${!BROKER_PORTS[@]}"; do
        if [[ $i -ne $index ]]; then
            start_broker "${BROKER_CONFIGS[$i]}"
        fi
    done

    # Send messages using active brokers
    send_messages "$random_port"

    echo "Sleeping for 15 minutes..."
    sleep 900  # 15 minutes in seconds
done
