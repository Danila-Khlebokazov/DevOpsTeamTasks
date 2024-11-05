# Kafka

### Task #1. Kafka cluster

Set up and configure an Apache Kafka cluster comprising three brokers named broker01, broker02, and broker03. Ensure
that the brokers start successfully and operate together as a unified cluster.
Create topic with multiple partitions and verify the distribution of these partitions across the brokers.

### Task #2. Kafka authorization

Configure Kafka to support either SASL or SSL for client-broker and inter-broker communication.
Ensure that producers can send messages and consumers can receive them successfully.
Examples of the configuration settings needed for clients (producers and consumers) to establish a secure connection

```json
{
  "sasl.username": "admin",
  "sasl.admin": "admin",
  "security.protocol": "SASL_SSL",
  "sasl.mechanism": "SCRAM-SHA-256",
  "ssl.ca.location": "/etc/ssl/certs/my.crt"
}

{
  "sasl.username": "admin",
  "sasl.admin": "admin",
  "security.protocol": "SASL_PLAINTEXT",
  "sasl.mechanism": "PLAIN"
}
```

Note – SASL_PLAINTEXT with PLAIN is easier to implement

### Task #3. Kafka without using Zookeeper

Set up Kafka in Kraft mode, eliminating the need for Zookeeper. Ensure that Kafka operates as expected by creating topics and verifying that messages can be produced and consumed successfully.

### Task #4. Kafka management
Implement a system where changes to Kafka topics (creation and deletion) can be proposed through merge requests.
Developers should be able to specify the following parameters in their requests

o Topic name

o Partitions

o Replication factor

o Delete policy

Add functionality for developers to propose changes to Kafka user permissions, also through merge requests. Developers should be able to specify which users or services have read, write, or admin rights to specific topics.
Prepare a GitLab CI/CD pipeline that should have at least two stages
1. Validate - validate the syntax and correctness of the proposed Kafka topic and user configuration files
2. Deploy – apply the changes to the Kafka instance after merge request is approved and merged

Your documentation should include details like
- How to setup the development environment
- How to create and submit merge requests for Kafka topic and permission
changes
- An overview of the CI/CD pipeline process
- An example with demonstration of the pipeline executing a sample merge
request that creates or deletes topic and modifies user permissions

### Task #5. Kafka cluster with systemd

Create and configure systemd for Apache Kafka, assigning one unit service per broker.
Use systemctl commands to stop specific Kafka brokers and verify that the cluster continues to operate correctly.

### Task #6. Kafka recovery
Implement a disaster recovery solution for the Kafka cluster.
Prepare a script that randomly stops one of the brokers every 15 minutes and continues sending messages to existing topics.
