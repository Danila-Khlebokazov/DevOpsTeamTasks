#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

topic_name=$1
message=$2

if [ -z "$topic_name" ] || [ -z "$message" ]; then
    echo "Please provide topic name and message"
    exit
fi


if [ -d "/kafka" ] && [ "$(ls -A /kafka)" ]; then
  echo "Kafka is already installed in /kafka"
else
  wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add -
  sudo add-apt-repository 'deb https://apt.corretto.aws stable main'
  sudo apt-get update
  sudo apt-get install -y java-11-amazon-corretto-jdk

  wget https://archive.apache.org/dist/kafka/3.0.0/kafka_2.13-3.0.0.tgz
  tar xzf kafka_2.13-3.0.0.tgz
  mv kafka_2.13-3.0.0 /kafka
  echo "Kafka installed in /kafka"
fi

# generate a random Cluster ID
id=$(/kafka/bin/kafka-storage.sh random-uuid)

if [ -z "$id" ]; then
  echo "Failed to generate Cluster ID"
  exit 1
fi
echo "Generated Cluster ID: $id"

# format the storage
/kafka/bin/kafka-storage.sh format -t $id -c /kafka/config/kraft/server.properties --ignore-formatted
echo "Cluster ID $id generated and storage formatted successfully."

# start the server
/kafka/bin/kafka-server-start.sh -daemon /kafka/config/kraft/server.properties


if ! /kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list | grep -q "^$topic_name$"; then
  /kafka/bin/kafka-topics.sh --create --topic $topic_name --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
  echo "topic $topic_name created."
else
  echo "topic $topic_name already exists."
fi

echo "$message" | /kafka/bin/kafka-console-producer.sh --topic $topic_name --bootstrap-server localhost:9092
echo "sent message '$message' to topic '$topic_name'."

echo "reading messages from topic"
/kafka/bin/kafka-console-consumer.sh --topic $topic_name --from-beginning --bootstrap-server localhost:9092
