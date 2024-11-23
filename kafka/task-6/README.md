# README: Kafka Disaster Recovery and Start Scripts


1. `kafka_disaster_recovery.sh`: Periodically stops and restarts Kafka brokers to simulate failure scenarios and test recovery.
2. `start-kafka-brokers-and-zookeeper.sh`: Starts Zookeeper and all Kafka brokers.


## Prerequisites

- **Kafka Installed**: Ensure Kafka is installed.
- **Configuration Files**:
    - `zookeeper.properties`: Zookeeper configuration file.
    - `broker01.properties`, `broker02.properties`, `broker03.properties`: Configuration files for Kafka brokers.


## Script 1: `kafka_disaster_recovery.sh`


1. **Stops All Brokers**:
    - Uses `kafka-server-stop.sh` to stop brokers gracefully.
    - Verifies if the broker stopped successfully.

2. **Starts All But One Broker**:
    - Randomly selects a broker to remain stopped.
    - Starts the remaining brokers with their respective configuration files.

3. **Sends Messages to Topics**:
    - Sends test messages to predefined topics (`topic1`, `topic2`) using active brokers.
    - Verifies that messages are sent successfully.

4. **Loops Periodically**:
    - Repeats the process every 15 minutes.

### Run

```bash
bash kafka_disaster_recovery.sh
```

## Script 2: `start-kafka-brokers-and-zookeeper.sh`

1. **Starts Zookeeper**:
    - Runs Zookeeper using `zookeeper.properties`.
    - Logs output to `zookeeper.log`.

2. **Starts Kafka Brokers**:
    - Iterates through broker configuration files to start brokers.
    - Logs output to `broker<id>.log` (e.g., `broker01.log`).

3. **Log Directory**:
    - Creates a dedicated log directory (`$KAFKA_HOME/logs`) for Zookeeper and brokers.

4. **Network Status**:
    - Checks if the expected ports (`2181`, `9092`, `9093`, `9094`) are in use after startup.

### Run

```bash
bash start-kafka-brokers-and-zookeeper.sh
```

