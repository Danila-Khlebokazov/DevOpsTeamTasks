import sys
from kafka.admin import KafkaAdminClient, NewTopic
import yaml

def apply_topics(file_path, broker):
    try:
        admin_client = KafkaAdminClient(bootstrap_servers=broker, request_timeout_ms=60000)
        print('connected?')
        with open(file_path, 'r') as f:
            data = yaml.safe_load(f)

        topics_to_create = []
        topics_to_delete = []

        # Loop through topics in the YAML file and check for the 'delete_policy'
        for topic in data.get('topics', []):
            action = topic.get('delete_policy', '').lower()
            if action == 'delete':
                # If delete_policy is 'delete', add the topic to the delete list
                topics_to_delete.append(topic['name'])
            else:
                # Otherwise, create the topic
                new_topic = NewTopic(
                    name=topic['name'],
                    num_partitions=topic['partitions'],
                    replication_factor=topic['replication_factor']
                )
                topics_to_create.append(new_topic)

        # Create topics
        if topics_to_create:
            admin_client.create_topics(new_topics=topics_to_create, validate_only=False)
            for topic in topics_to_create:
                print(f"Created topic: {topic.name}")

        # Delete topics
        if topics_to_delete:
            admin_client.delete_topics(topics=topics_to_delete)
            for topic in topics_to_delete:
                print(f"Deleted topic: {topic}")

    except Exception as e:
        print(f"Error applying topics: {e}")
        sys.exit(1)

def apply_permissions(file_path, broker):
    try:
        with open(file_path, 'r') as f:
            data = yaml.safe_load(f)

        for permission in data.get('permissions', []):
            print(f"Permissions mock: User {permission['user']} granted access {permission['access']} on topics.")
    except Exception as e:
        print(f"Error applying permissions: {e}")
        sys.exit(1)

if __name__ == "__main__":
    try:
        topics_file = sys.argv[1]
        permissions_file = sys.argv[2]
        broker = sys.argv[3]  # Remote Kafka broker address (e.g., <public_ip>:9092)
        apply_topics(topics_file, broker)
        apply_permissions(permissions_file, broker)
        print("Deployment completed!")
    except IndexError:
        print("Usage: python deploy_changes.py <topics_file> <permissions_file> <broker>")
        sys.exit(1)
