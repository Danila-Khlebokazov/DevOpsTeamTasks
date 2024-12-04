## Task #3. Job scaling

Scale the previously deployed service to multiple instances while ensuring minimal
downtime through rolling updates and health checks.

## Usage

```bash
nomad job run deploy-dynamic.nomad
```

here are 2 cases to check.

`image = "danilakhlebokazov/task-2-nomad:local` - this is for initial
`image = "danilakhlebokazov/task-2-nomad:error-2` - this is for checking