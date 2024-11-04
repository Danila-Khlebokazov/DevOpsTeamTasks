# Enable and configure transit secrets engine
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN="$(cat /home/root-token.txt)"
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
path "auth/token/create" {
   capabilities = ["update", "create"]
}
EOF

# Create a token for Vault 2 to use for root key encryption
sudo VAULT_TOKEN=$VAULT_ADDR VAULT_ADDR=$VAULT_TOKEN vault token create -orphan -policy="autounseal" -wrap-ttl=24h -period=24h -field=wrapping_token > /home/wrapping-token.txt



