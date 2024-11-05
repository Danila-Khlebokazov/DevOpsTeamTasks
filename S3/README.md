# S3

### Task #1. MinIO cluster

Set up a distributed cluster with 3 MinIO nodes, ensuring each node runs as a separate systemd unit service using docker container(-s).
Verify that data is properly distributed and replicated across all nodes. Simulate node failures to confirm data availability and resilience under various conditions.

### Task #2. Data synchronization

Synchronize data between your local system and MinIO bucket. Ensure that a bucket is created in MinIO (if it does not already exist) to act as the target for synchronization.
Configure the synchronization process to run between your local system and the MinIO bucket every minute.
For additional assistance, refer to https://rclone.org/

### Task #3. CI/CD
Develop GitLab CI/CD pipeline to manage MinIO buckets and users through configuration files. Pipeline should validate their syntax and applies changes. Sensitive information should be stored in HashiCorp Vault.
Include a review stage that allows administrators to preview changes before they are applied to the MinIO server. Implement a rollback step or script to revert any changes if necessary.
Incorporate logic to detect changes in the configuration files since the last deployment, ensuring that updates are only applied when changes are present.
Add integration with notification system to alert administrators when configurations are updated or deployed, providing clear communication and transparency.