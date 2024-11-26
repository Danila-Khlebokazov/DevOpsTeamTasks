# Terraform - virtual machine

## Overview

This project sets up and configures a virtual machine, create a user named ansible with a root permissions using Terraform in Azure.

---

## Table of Contents

1. [Overview](#overview)
2. [Tutorials](#tutorials)
3. [How-To Guides](#how-to-guides)
4. [Explanations](#explanations)
5. [Reference](#reference)
6. [Appendix](#appendix)

---

### Tutorials

- **Installation**:
    1. Install [Terraform](https://www.terraform.io/downloads.html).
    2. Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

- **Setup**:
    1. `az login` to setup azure account
    2. Set subscription_id according your Azure account in [main.tf](main.tf)

- **Quick Start**: A short guide on running the project or performing basic actions.
    1. `terraform init`
    2. `terraform apply`
    3. To connect to server using ssh use `terraform output -raw private_key` and save output to your /.ssh/

### Explanations

Network security group is used to allow connection via ssh
I couldn't add group with name ansible, because Azure automatically creates it.
![](https://github.com/user-attachments/assets/3542e4e8-e865-479a-9ebd-cc534f6b50d5)
SSH keys are generated and managed using Terraform's tls_private_key resource and they saving it .tfstate file

### Appendix

#### Terraform configuration

![Code_KYwxfrxyzu](https://github.com/user-attachments/assets/7e6dfef5-8f9a-4901-8c7f-5a7d68071192)
![Code_oyuLVbmlsH](https://github.com/user-attachments/assets/179b2086-654e-4cfb-acbc-b43fdc35b676)
![Code_mkI3K51OMM](https://github.com/user-attachments/assets/e9cbf24d-4dc6-4792-9896-d143ac19f090)
![Code_UZV0Sehyju](https://github.com/user-attachments/assets/da42a28d-c986-4d26-9f75-903623428e36)

#### Resources in Azure

![msedge_LROI5q3eYT](https://github.com/user-attachments/assets/e831a13e-3619-4bae-8e27-d355869527b2)

#### User with root access named ansible

![WindowsTerminal_T0DPfTxvKU](https://github.com/user-attachments/assets/0236edc3-ba98-472e-8fc2-62e6f4a1d2b8)

### References

- Grant root access to user - [link](https://www.shellhacks.com/how-to-grant-root-access-user-root-privileges-linux/)
- Create SSH key in Terraform - [link](https://stackoverflow.com/questions/49743220/how-to-create-an-ssh-key-in-terraform)
...
