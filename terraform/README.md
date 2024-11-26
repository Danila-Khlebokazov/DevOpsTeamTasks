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
SSH keys are generated and managed using Terraform's tls_private_key resource and they saving it .tfstate file

### References

- Grant root access to user - [link](https://www.shellhacks.com/how-to-grant-root-access-user-root-privileges-linux/)
- Create SSH key in Terraform - [link](https://stackoverflow.com/questions/49743220/how-to-create-an-ssh-key-in-terraform)
...
