terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  description = "The Azure region where the resources will be deployed."
}

variable "resource_group_name" {
  description = "The name of the existing resource group where resources will be deployed."
}

variable "key_vault_name" {
  description = "The name of the Azure Key Vault where secrets are stored."
}

variable "secret_name" {
  description = "The name of the secret in the Azure Key Vault containing the domain password."
}

variable "admin_username" {
  description = "The admin username for the Windows Virtual Machine."
}

variable "admin_password" {
  description = "The admin password for the Windows Virtual Machine."
}

variable "domain_name" {
  description = "The name of the Active Directory domain to join."
}

variable "domain_username" {
  description = "The username of an account with permissions to join machines to the domain."
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "domain_password" {
  name         = var.secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_network_interface" "nic" {
  name                = "myNIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "myVM"
  location            = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  size               = "Standard_B2ms"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  admin_username = var.admin_username
  admin_password = var.admin_password

  provisioner "local-exec" {
    command = <<-EOT
      powershell.exe Add-Computer -DomainName "${var.domain_name}" -Credential "${var.domain_username}" -Restart
    EOT
  }
}

output "vm_id" {
  value = azurerm_windows_virtual_machine.vm.id
}
