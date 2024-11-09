### How to do

References: https://docs.gitlab.com/ee/ci/secrets/hashicorp_vault.html

Create Vault policies to control which users or services can access specific secrets.

```bash
vault auth enable jwt
```

```bash
vault policy write project1-test - <<EOF
# Policy name: project1-test
#
# Read-only permission on 'test/data/project1*' path
path "test/data/project1*" {
  capabilities = [ "read" ]
}
EOF
```

```bash
vault write auth/jwt/role/project1-test-role - <<EOF
{
  "role_type": "jwt",
  "policies": ["project1-test"],
  "token_explicit_max_ttl": 60,
  "user_claim": "user_email",
  "bound_audiences": "https://test.vault.kz",
  "bound_claims": {
    "ref": "main",
    "ref_type": "branch"
  }
}
EOF
```

1. Direct Vault integration from Gitlab CI/CD pipeline – pipeline extracts secrets from Vault and passing them to the
   deployment stage without exposing in the code or pipeline configurations

```yaml
job_with_secrets:
  image: vault:1.3.2  # need to use vault command
  id_tokens:
    VAULT_ID_TOKEN:
      aud: https://test.vault.kz  # matches the bound_audiences
  script:
    - export VAULT_ADDR=$VAULT_SERVER_URL
    - export VAULT_TOKEN="$(vault write -field=token auth/jwt/login role=$VAULT_AUTH_ROLE jwt=$VAULT_ID_TOKEN)"
    - export TEST_SECRET="$(vault kv get -field=TEST test/project2)"
    - echo $TEST_SECRET
    - if [[ "$TEST_SECRET" != "valid2" ]]; then exit 1; fi
```

2. Server-side secret retrieval during application runtime - set up the pipeline to deploy the application without
   embedding any secrets. Instead, after deployment, the application will retrieve the necessary secrets from Vault
   during its execution

```yaml
deploy:
  stage: deploy
  script:
    - ssh $SSH_USER@$VM_IPADDRESS  <<EOF
    - sudo apt-get update && sudo apt-get install python3 python3-pip virtualenv -y
    - export VAULT_ADDR=$VAULT_SERVER_URL
    - export VAULT_TOKEN=$VAULT_SECRET_TOKEN
    - sudo rm -rf app
    - git clone $CI_REPOSITORY_URL app
    - cd app
    - vault kv get -format=json "$VAULT_SECRET_PATH" | jq -r '.data.data | to_entries[] | "\(.key)=\(.value)"' > .env
    - sudo docker-compose up -d 
```

Firstly secrets go to .env file and then application reads them from there.
And here is the docker-compose file:

```yaml
services:
  test:
    image: ubuntu:latest
    command:
      - echo $TEST
    env_file:
      - .env
```
