### Project Name: Kafka without using Zookeepe

---

### Overview
This documentation provides a Bash script to set up 
an Apache Kafka cluster in KRaft mode, which eliminates
the need for Zookeeper. 
The script installs Java, sets up Kafka,
and verifies functionality by creating a specified
topic and producing/consuming messages.
## How to Run

```bash
sudo bash kafka_KRaft_install.sh <topic_name> <message>
```
- <_topic_name_> the name of the topic to be created.
- <_message_> the message to be sent to the topic.

**Command will**
1. Install Java and Kafka if they are not already installed. 
2. Set up Kafka in KRaft mode by generating a Cluster ID and formatting the storage. 
3. Test Kafka by creating the specified topic, sending the provided message, and reading it from the topic.

## References
1. **KRaft: Apache Kafka Without ZooKeeper** - https://developer.confluent.io/learn/kraft/