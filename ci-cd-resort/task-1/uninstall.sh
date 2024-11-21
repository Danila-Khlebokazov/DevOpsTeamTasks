sudo systemctl stop vault
sudo apt remove --purge vault -y
sudo apt autoremove -y
sudo rm -rf /etc/vault.d
sudo rm -rf /opt/vault
sudo rm -f /usr/bin/vault
sudo rm -f /home/root-token.txt
sudo rm -f /home/unseal-key.txt
