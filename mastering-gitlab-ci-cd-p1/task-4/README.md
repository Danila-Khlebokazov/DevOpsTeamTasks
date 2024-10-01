## The Project

https://gitlab.com/askaroe/gitlabcicd-task4

## Task Description

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