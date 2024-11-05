# DB Management

### Task #1. Prepare optimized query

Create two SQL functions to fetch movie recommendations that exclude movies listed in the reaction table, and optimize
the performance of your queries and related tables. Analyze and document how your optimizations impact query
performance. You should document every change you make and explain why it improves / not improves the performance.
Functions

1. get_recommendations_by_device_id - eturns movie recommendations for a user based on their device_id, excluding movies
   present in the reaction table
2. get_recommendations_by_user_id - returns movie recommendations for a user based on their user_id, excluding movies
   present in the reaction table
   Simulate 1000 / 10 000 RPS and measure performance.
   What could be useful: indexes, partitioning, caches, connection pool, postgresql.conf
   Note: connection pooler is required, hi pgbouncer

### Task #2. Flyway

Create a monorepository that contains configurations for two separate databases (production and test). Implement Flyway
migrations for both databases and set up a multi-stage CI/CD pipeline in GitLab that handles migrations and deployments
for each database environment.
Each environment's pipeline should trigger on changes to the respective environment folders.

```plaintext
/monorepo
├── /production
│ ├── /conf
│   │   └── flyway.toml
│ ├── /sql
│ └── .gitlab-ci.yml ├── /test
│ ├── /conf
│   │   └── flyway.toml
│ ├── /sql
│ └── .gitlab-ci.yml
└── .gitlab-ci.yml
```

Add migrations for changes made in task #1. Required stages are validate and migrate.
Note: your database is already exists and contain tables with structure from task #1, initial structure, not changes.