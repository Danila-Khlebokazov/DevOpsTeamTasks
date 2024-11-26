output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "private_key" {
  value     = tls_private_key.admin_ssh_key.private_key_pem
  sensitive = true
}
