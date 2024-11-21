# Enable and configure transit secrets engine
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN="$(cat /home/root-token.txt)"
vault secrets enable -path=transit transit || echo "Transit secrets engine already enabled."

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
# shellcheck disable=SC2024
sudo bash -c 'VAULT_ADDR=http://127.0.0.1:8200 VAULT_TOKEN=$(cat /home/root-token.txt) vault token create -orphan -policy="autounseal" -wrap-ttl=24h -period=24h -field=wrapping_token > ./wrapping-token.txt'



