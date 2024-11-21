
#Part of installing second instance of vault

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

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

if [ ! -s /home/root-token.txt ]; then
  echo "Please write into /home/root-token.txt the root token of the first instance"
  exit 1
fi


wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault

sudo cp /lib/systemd/system/vault.service /lib/systemd/system/vault2.service
sudo sed -i 's#ExecStart=/usr/bin/vault server -config=/etc/vault.d/vault.hcl#ExecStart=/usr/bin/vault server -config=/etc/vault2.d/vault2.hcl#g' /lib/systemd/system/vault2.service
sudo sed -i 's#User=vault#User=root#g' /lib/systemd/system/vault2.service


export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN=$(cat /home/root-token.txt)
export UNWRAPPED_TOKEN=$(vault unwrap -field=token $(cat ./wrapping-token.txt))
sudo mkdir -p /etc/vault2.d/
sudo tee /etc/vault2.d/vault2.hcl > /dev/null <<EOF
ui = true
disable_mlock = true

storage "raft" {
  path = "/opt/vault/vault-2"
  node_id = "vault-2"
}

listener "tcp" {
  address     = "127.0.0.1:8100"
  tls_disable = true
}

seal "transit" {
  address = "http://127.0.0.1:8200"
  key_name = "autounseal"
  mount_path = "transit/"
  token = "${UNWRAPPED_TOKEN}"
  tls_skip_verify = true
}

api_addr      = "http://127.0.0.1:8100"
cluster_addr  = "http://127.0.0.1:8101"
EOF

sudo mkdir -p /opt/vault/vault-2

sudo chown -R root:root /opt/vault/vault-2
sudo chmod -R 700 /opt/vault/vault-2
sudo systemctl daemon-reload
sudo systemctl enable vault2
sudo systemctl start vault2



init_credits=$(VAULT_ADDR="http://127.0.0.1:8100" vault operator init -format=json)

export VAULT_TOKEN2=$(echo $init_credits | jq -r ".root_token")
echo $VAULT_TOKEN2 > /home/root-token2.txt
