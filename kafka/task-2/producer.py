import time

from confluent_kafka import Producer

BATCH_SIZE = 10_000
MESSAGE_NUMS = 100000

p = Producer(
    {
        'bootstrap.servers': '192.168.65.3',
        'security.protocol': 'SASL_PLAINTEXT',
        'sasl.mechanisms': 'PLAIN',
        'sasl.username': 'alice',
        'sasl.password': 'alice-secret',
    }
)

some_data_source = ['message {}'.format(i) for i in range(MESSAGE_NUMS)]


def delivery_report(err, msg):
    """ Called once for each message produced to indicate delivery result.
        Triggered by poll() or flush(). """
    if err is not None:
        print('Message delivery failed: {}'.format(err))
    else:
        print('Message delivered to {} [{}]'.format(msg.topic(), msg.partition()))


start_time = time.time()

for idx in range(0, len(some_data_source), BATCH_SIZE):
    batch = some_data_source[idx:idx + BATCH_SIZE]
    for data in batch:
        p.produce('topic1', data.encode('utf-8'))
        print('Producing message: {}'.format(data))
        p.flush()

end_time = time.time()

p.flush()

print(MESSAGE_NUMS / (end_time - start_time))
