variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus2"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  default     = "devopssila"
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
  default     = "Devopssila5"
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
