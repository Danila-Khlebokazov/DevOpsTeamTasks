# Start the Vault 1 server in dev mode
# The system output will be stored in the vault-1.log file
vault server -dev -dev-root-token-id root > vault-1.log 2>&1 &

sleep 1

# Set the environment variables: VAULT_ADDR and VAULT_TOKEN
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN="write here your token" #change on your root token if it's not equals root

# Enable and configure transit secrets engine
vault secrets enable transit
vault write -f transit/keys/autounseal

# Create an autounseal policy
vault policy write autounseal -<<EOF
path "transit/encrypt/autounseal" {
   capabilities = [ "update" ]
}

path "transit/decrypt/autounseal" {
   capabilities = [ "update" ]
}
EOF

# Create a token for Vault 2 to use for root key encryption
vault token create -orphan -policy="autounseal" -wrap-ttl=120 -period=24h -field=wrapping_token > wrapping-token.txt
