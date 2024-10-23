# CI/CD Resort

### Task 1. Installing HashiCorp Vault

Write a Bash script that fully automates the process of installing HashiCorp Vault on your system. The script should configure Vault with the necessary settings, initialize, unseal and set up Vault as a systemd service to ensure it starts automatically and is managed by the system.
You’re expected to submit the bash script file named install_vault.sh that performs all the tasks described above. You script will be evaluated based on the following criteria
- Functional requirements
o Script successfully installs Vault
o Initializes and unseals Vault
o Sets up as a systemd service that runs correctly
- Non-functional requirements
o Includes proper error handling
o Idempotent – meaning it can be run multiple times without causing
issues
o Script should store secrets securely and shouldn’t display them during
execution
o Restrict permissions for all required files to prevent unauthorized
access

### Task 2. Auto-unseal

Configure Vault to auto-unseal using the transit secrets engine method. This involves setting up a secondary Vault instance that acts as a Transit auto-unseal server. You can install vault either on a secondary server or as a separate instance on the same server.
Both Vault instances should be installed using script from task #1.

### Task 3. Secure secrets management in Gitlab CI/CD using HashiCorp Vault

Create Vault policies to control which users or services can access specific secrets. For example, only production servers have access to production secrets.
Create two types of pipelines that interact with Vault to securely manage secrets
1. Direct Vault integration from Gitlab CI/CD pipeline – pipeline extracts secrets from Vault and passing them to the deployment stage without exposing in the code or pipeline configurations
2. Server-side secret retrieval during application runtime - set up the pipeline to deploy the application without embedding any secrets. Instead, after deployment, the application will retrieve the necessary secrets from Vault during its execution

### Task 4. Sonatype Nexus

Install Nexus and set up docker group repository. Nexus installation must be done using a script, ensuring idempotency, and should be run as systemd service.
Setup integration with Gitlab CI/CD pipeline ( minimum – stage that build docker image and push into nexus + deploy stage where your builded image will be pulled from nexus )

### Task 5. SonarQube

Install and integrate SonarQube as part of a CI/CD pipeline to perform static code analysis. The SonarQube installation should be automated using a script, ensuring idempotency, and it must be set up as a systemd service
Automate sending of the SonarQube analysis report to specified email addresses after each code analysis run
