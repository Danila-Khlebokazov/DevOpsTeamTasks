#! /bin/bash

# reference https://developer.hashicorp.com/vault/install

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# check if wget and gpg are installed
if ! command -v wget &> /dev/null
then
    echo "wget could not be found"
    exit
fi

if ! command -v gpg &> /dev/null
then
    echo "gpg could not be found"
    exit
fi


wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault

sudo systemctl enable vault

sudo systemctl start vault

vault -autocomplete-install

export VAULT_ADDR="http://127.0.0.1:8200"

sudo mkdir -p /etc/vault.d/

sudo tee /etc/vault.d/vault.hcl > /dev/null <<EOF
ui = true

storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
}

disable_mlock = true
api_addr      = "http://127.0.0.1:8200"
cluster_addr  = "http://127.0.0.1:8201"
EOF

sudo mkdir -p /opt/vault/data

sudo systemctl restart vault

vault status

export VAULT_TOKEN=$(vault operator init -key-shares=1 -key-threshold=1 -format=json | jq -r ".root_token")
echo $VAULT_TOKEN > /home/root-token.txt