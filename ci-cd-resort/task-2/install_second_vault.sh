#!/bin/bash

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

sudo cp /lib/systemd/system/vault.service /lib/systemd/system/vault2.service

sudo sed -i 's#ExecStart=/usr/bin/vault server -config=/etc/vault.d/vault.hcl#ExecStart=/usr/bin/vault server -config=/etc/vault2.d/vault2.hcl#g' /lib/systemd/system/vault2.service
sudo sed -i 's#User=vault#User=root#g' /lib/systemd/system/vault2.service

sudo systemctl enable vault2
sudo systemctl start vault2

export VAULT_ADDR="http://127.0.0.1:8100"


sudo mkdir -p /etc/vault2.d/

sudo tee /etc/vault2.d/vault2.hcl > /dev/null <<EOF
ui = true

storage "file" {
  path = "/opt/vault2/data"
}

listener "tcp" {
  address     = "0.0.0.0:8100"
  tls_disable = true
}

disable_mlock = true
api_addr      = "http://127.0.0.1:8100"
cluster_addr  = "http://127.0.0.1:8101"
EOF

sudo mkdir -p /opt/vault2/data

sudo systemctl restart vault2

vault status

vault operator init
