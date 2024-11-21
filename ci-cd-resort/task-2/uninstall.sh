sudo systemctl stop vault2
sudo rm -f /lib/systemd/system/vault2.service
sudo systemctl daemon-reload
sudo rm -rf /etc/vault2.d
sudo rm -rf /opt/vault/vault-2
sudo rm -f .//wrapping-token.txt
