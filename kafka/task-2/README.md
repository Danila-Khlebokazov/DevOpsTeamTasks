# Kafka Authorization

References: https://www.slingacademy.com/article/how-to-enable-sasl-authentication-in-kafka/

## 1. Configure SASL PLAINTEXT on Kafka

### 1.1. Broker config

```properties
broker.id=1
listeners=SASL_PLAINTEXT://:29092,SASL_PLAINTEXT_INTERNAL://:9092,SASL_PLAINTEXT_EXTERNAL://:9093
advertised.listeners=SASL_PLAINTEXT://192.168.65.3:29092,SASL_PLAINTEXT_INTERNAL://192.168.65.3:9092,SASL_PLAINTEXT_EXTERNAL://192.168.65.3:9093
listener.security.protocol.map=SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_PLAINTEXT_INTERNAL:SASL_PLAINTEXT,SASL_PLAINTEXT_EXTERNAL:SASL_PLAINTEXT
inter.broker.listener.name=SASL_PLAINTEXT
sasl.enabled.mechanisms=PLAIN
sasl.mechanism.inter.broker.protocol=PLAIN
log.dirs=C:/kafka/kafka-logs-broker01
zookeeper.connect=localhost:2181
offsets.topic.replication.factor=1
```

### 1.2. JAAS config

```conf
KafkaServer {
  org.apache.kafka.common.security.plain.PlainLoginModule required
  username="admin"
  password="admin-secret"
  user_admin="admin-secret"
  user_alice="alice-secret";
};

KafkaClient {
  org.apache.kafka.common.security.plain.PlainLoginModule required
  username="alice"
  password="alice-secret";
};
```

### 1.3. Start Kafka

```bash
export KAFKA_OPTS="-Djava.security.auth.login.config=config/kafka_server_jaas.conf"
bin/kafka-server-start.sh config/broker01-sasl.properties
```

### 1.4. Create topic

```bash
bin/kafka-topics.sh --create --topic test --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3 --command-config config/client-sasl.properties
```

## 2. Produce and consume

### 2.1. Produce

```python
from confluent_kafka import Producer

p = Producer(
    {
        'bootstrap.servers': '192.168.65.3',
        'security.protocol': 'SASL_PLAINTEXT',
        'sasl.mechanisms': 'PLAIN',
        'sasl.username': 'alice',
        'sasl.password': 'alice-secret',
    }
)

p.produce('topic1', "test_message".encode('utf-8'))
p.flush()
```

### 2.2. Consume

```python
from confluent_kafka import Consumer

c = Consumer({
    'bootstrap.servers': '192.168.65.3',
    'group.id': 'test_group',
    "enable.auto.commit": False,
    'security.protocol': 'SASL_PLAINTEXT',
    'sasl.mechanisms': 'PLAIN',
    'sasl.username': 'alice',
    'sasl.password': 'alice-secret',
})

c.subscribe(['topic1'])

while True:
    msg = c.poll(0.5)

    if msg is None:
        continue

    print('Received message: {}'.format(msg.value().decode('utf-8')))
```