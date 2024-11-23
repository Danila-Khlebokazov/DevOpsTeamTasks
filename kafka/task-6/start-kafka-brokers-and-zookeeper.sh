#!/bin/bash

# Kafka installation directory
KAFKA_HOME="/mnt/c/kafka/kafka_2.12-3.9.0"

# ZooKeeper and Broker configuration files
ZOOKEEPER_CONFIG="$KAFKA_HOME/config/zookeeper.properties"
BROKER_CONFIGS=("$KAFKA_HOME/config/broker01.properties" "$KAFKA_HOME/config/broker02.properties" "$KAFKA_HOME/config/broker03.properties")

# Log files for ZooKeeper and brokers
LOG_DIR="$KAFKA_HOME/logs"
mkdir -p "$LOG_DIR"

# Function to start ZooKeeper
start_zookeeper() {
    echo "Starting ZooKeeper..."
    "$KAFKA_HOME/bin/zookeeper-server-start.sh" "$ZOOKEEPER_CONFIG" > "$LOG_DIR/zookeeper.log" 2>&1 &
    ZOOKEEPER_PID=$!
    echo "ZooKeeper started with PID: $ZOOKEEPER_PID"
}

# Function to start Kafka brokers
start_brokers() {
    for config in "${BROKER_CONFIGS[@]}"; do
        broker_id=$(basename "$config" | sed 's/[^0-9]*//g') # Extract broker ID
        echo "Starting Broker $broker_id with config: $config..."
        "$KAFKA_HOME/bin/kafka-server-start.sh" "$config" > "$LOG_DIR/broker$broker_id.log" 2>&1 &
        echo "Broker $broker_id started."

    done
}

# Start ZooKeeper
start_zookeeper

# Give ZooKeeper time to initialize
sleep 5

# Start Kafka brokers
start_brokers

echo "All services started. Logs are located in $LOG_DIR"
lsof -i :2181
lsof -i :9092
lsof -i :9093
lsof -i :9094
