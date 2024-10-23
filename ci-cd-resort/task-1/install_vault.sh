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

systemctl enable vault

systemctl start vault

vault -autocomplete-install

export VAULT_ADDR="https://0.0.0.0:8200"
export VAULT_TOKEN="1"

echo << EOF >> /etc/vault.d/vault.hcl
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
}

disable_mlock = true
api_addr      = "https://127.0.0.1:8200"
cluster_addr  = "https://127.0.0.1:8201"
EOF

server

vault status

vault operator init