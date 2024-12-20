# Kafka cluster with systemd

## Prerequisites

1. **Kafka Installed**: Ensure that Kafka is already installed in the `/opt/kafka` directory.

## Files Explanation

### 1. **Bash Script (`setup`)**

- Automates the setup of the Kafka cluster.
- Creates a `kafka` system user for running Kafka services.
- Configures three Kafka brokers and a Zookeeper instance.

### 2. **Template Files**

- `templates/zookeeper.service`: Systemd service file for Zookeeper.
- `templates/broker.service`: Systemd service file template for Kafka brokers.

### 3. **Configuration File**

- `config/broker.properties`: Base configuration file for Kafka brokers. This is modified to create unique
  configurations for each broker.



## Script Functionality

1. **User Creation**:
    - Creates a `kafka` user with a home directory.
    - Changes ownership of `/opt/kafka` to the `kafka` user.

2. **Zookeeper Setup**:
    - Copies the `zookeeper.service` file to the systemd directory.
    - Configures Zookeeper as a systemd service.

3. **Kafka Broker Configuration**:
    - Generates three unique configuration files for Kafka brokers based on the base `broker.properties` file.
    - Updates the following fields in each broker's configuration:
        - `broker.id`: Unique ID for each broker (`1`, `2`, `3`).
        - `listeners` and `advertised.listeners`: Sets unique ports (`9092`, `9093`, `9094`).
        - `log.dirs`: Specifies unique log directories for each broker.
        - `offsets.topic.replication.factor`: Sets replication factor to `3`.

4. **Kafka Broker Service Setup**:
    - Creates systemd service files for each Kafka broker.
5. **Service Management**:
    - Reloads the systemd daemon to register new services.
    - Enables and starts the Zookeeper service.
    - Enables and starts all three Kafka broker services.

---

## Steps to Execute

1. **Run**:
   ```bash
   sudo bash setup.sh
   ```
