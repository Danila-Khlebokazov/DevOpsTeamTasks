# Mastering Gitlab CI/CD

### Task 1

Scripts

- [install_gitlab_runner.sh](task-1%2Finstall_gitlab_runner.sh)
- [register_gitlab_runner.sh](task-1%2Fregister_gitlab_runner.sh)
- [cleanup.sh](task-1%2Fcleanup.sh)

Write a script install_gitlab_runner.sh that installs gitlab runner on the server using the official installation
instructions. Configures the gitlab runner to automatically start on boot. Your script should be idempotent, meaning it
can be run multiple times without causing issues.
Write a script register_gitlab_runner.sh to register the gitlab runner with your gitlab group using group-specific
registration token. Use shell executor. The registration process should be fully automated and shouldn’t require manual
input except passing URL (yes, you can’t take runner registration token directly from UI).
Write a script cleanup.sh to clean up the gitlab runner by stopping, unregistering, and removing it from the server when
needed.

### Task 2

Develop a simple REST API and upload your code to GitLab. Your repository should be under a public group that you
create.
Create a CI/CD pipeline that deploys the application to your Linux server. The pipeline should connect to the server via
SSH and start the API service using systemd unit files.
The deployment job should require manual approval before execution.
Your CI/CD pipeline should only run when there are changes in the code and only
on the master branch or branches following the release-* naming convention. Configure your pipeline to send the results
to a Telegram channel.
Ensure that secrets (e.g., my_secret_value=mypassword) are not stored in plain text within your GitLab CI/CD
configuration.
Add a link to your deployed service as an environment variable within your CI/CD
pipeline - https://docs.gitlab.com/ee/ci/environments/#in-your-gitlab-ciyml-file

### Task 3

Add monitoring stage that checks whether the application is running correctly by sending HTTP requests to a health-check
endpoint or running a basic status check script. If the health check fails (i.e., the endpoint is unreachable, or the
service is down), the pipeline should register this failure (exit with status 1)
In case of failure in the monitoring stage, the pipeline should execute a remediation stage that attempts to restart the
application on the Linux server using another script. This self-healing mechanism should be fully automated and
triggered only when the monitoring stage fails.

### Task 4

Create a GitLab CI/CD pipeline that processes JSON configuration changes and conditionally executes jobs based on
detected differences. The pipeline should be capable of identifying changes in specified keys and ensuring that
subsequent jobs run only when relevant changes have occurred.
Create a job compare_json that compares two json files (config_old.json and config_new.json), identifying changes in
specific keys (database, api_url, feature_flag and any newly added settings). Based on the detected changes, generate
indicators that signal whether subsequent jobs should be triggered.
Create separate jobs database_migration, feature_test and deploy_api that should only run if the relevant changes are
detected. Each job should validate whether it has valid input before executing and exit gracefully if no changes are
found. Each job should provide clear log messages when it doesn't execute due to the absence of relevant changes. (
Example for database_migration: No database changes detected. Skipping job)
Create final job report that generates a summary based on the detected changes. This job should always run, even if no
changes were detected, to provide a final overview of the pipeline execution.

Example

```json
# config_old.json
{
"database": "old_db",
"api_url": "https://old.api.example.com", "feature_flag": "off"
}
# config_new.json
{
"database": "old_db",
"api_url": "https://new.api.example.com", "feature_flag": "on",
"new_setting": "enabled"
}
# diff_report.json
{
"added": {
"new_setting": "enabled"
},
"removed": {
}, "changed": {
"api_url": "https://new.api.example.com", "feature_flag": "on"
},
"unchanged": {
"database": "old_db"
}
}
Notes
- diff_report.json should be created in compare_json job - use jq to compare json
```