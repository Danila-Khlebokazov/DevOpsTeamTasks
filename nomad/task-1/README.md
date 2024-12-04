## TASK

Deploy PostgreSQL using Nomad. Configure persistent volumes to retain data.
Use Nomad to periodically back up the database to local or remote location.
Simulate failure and restore the database from backup.

## USAGE
You need **docker** and **nomad** already installed.

1. Fill required placeholders with directory for backups and nomad data in **./config/nomad.hcl** and **./postgres-backup.nomad**
2. Run nomad agent using `nomad agent -config=./config`
3. Run both given jobs using `nomad job run <name-of-job>`