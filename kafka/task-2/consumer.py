from confluent_kafka import Consumer
import time

BATCH_SIZE = 10_000
MESSAGE_NUMS = 1_000_000
msg_count = 0

c = Consumer({
    'bootstrap.servers': '192.168.65.3',
    'group.id': 'test_group',
    'security.protocol': 'SASL_PLAINTEXT',
    'sasl.mechanisms': 'PLAIN',
    'sasl.username': 'alice',
    'sasl.password': 'alice-secret',
})

c.subscribe(['topic1'])

try:
    input("start: enter")
    start_time = time.time()
    while True:
        msg = c.poll(0.5)

        if msg is None:
            # print("No message")
            continue

        print('Received message: {}'.format(msg.value().decode('utf-8')))
        msg_count += 1
        if msg_count % BATCH_SIZE == 0:
            c.commit(asynchronous=False)
finally:
    c.close()
    print(MESSAGE_NUMS / (time.time() - start_time))
