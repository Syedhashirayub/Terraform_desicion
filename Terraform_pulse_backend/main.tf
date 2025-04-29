############################
# 🔧 RESOURCE GROUP
############################
resource "azurerm_resource_group" "rg" {
  name     = "nifi-final"
  location = "Central India"
}

############################
# 🌐 VIRTUAL NETWORK (Kafka)
############################
resource "azurerm_virtual_network" "vnet_kafka" {
  name                = "kafka-vm-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "main-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_kafka.name
  address_prefixes     = ["10.0.1.0/24"]
}

############################
# 🔐 SSH KEYS
############################
resource "azurerm_ssh_public_key" "nifi_key" {
  name                = "nifi-server_key"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDITO9GgRWggUMohKdPpe8ATWa58fmYHYFlHXQjdKnlclm8EPnBvTwNQZk5giOnx7xm9PhWYwwqAr2WOQfyHnod/zXRXv6u5kgqdMjwUzEmwgPQg6bpKODLOHGyGotRg+gfdmEdWQqiXOfzGSJOX14XB7w7AvV1QloXAhqWuxncdznWpuoIBYt5RKXQ2H08O33uMNjsJ30MwvBKzYM0Ldc8ym4Jbq7Av9y1q9VGBQhbEKUw69J8n6sF6VIUz1cmkCUnSkbtUI2Xy78a1sQX7UxGX8acfizznraTDBaS2G975CZQ7xAEn5Wjb5dSNYTgo5Nu2Bj+utyYnvEHZU++SrQFtmTVawOKgVE5SMVL1JinsbIn8HYirfhBe554F06JD9EX3sX+tpCZBankUA1gCtSNcxn4D9a33+jj/xpbwDwEZJWWfoaJj49ns4DncAM/wBd5UKmgj4iTKOvu8hVTvWEICqPpsNluLy4DT3arskRqhZQYu3iYrC4tmmjj4CtIVuU= generated-by-azure"
}

resource "azurerm_ssh_public_key" "decision_key" {
  name                = "Decision-Pulse-Backend_key"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIuQpa5+KE5upahRc8CLyes2PiYSpngvondg+1LsdGjjmgIzctYwp2hmg/2hNrFdIM/geZ/ob484VTafEyZJVkbm6rVFdIlpt+HKeVoD+XPwAHnhL5X3yHh3nwcTsEA2uIZ4OKITrcC4wbkAj0uzDi0qxAATgjNg2ehnrlA62ekEe3UPwUmbqXlUOUaB52K3fgZMQWSoWOpi/kEKMb04uMctwxIO6vphzEwBUUK2qajgZWjZWCkvZUEBmT1furyTJXIipuk+NmptpAIXUH9kOmheQesV8TJLkSb3McNu5iqNMY07rhvFhGvT3CSrew9HudxPE7X3dY5xG8s9uTin/+TLwZhs/zfe8NzwoOTjW4s7GEqNsvI99pr+0r/cY1O+dP8s8okN4s7dLi8NaiNCCbIr5gWmXopVuOVzVIQDsxNMlgC+pu3LeGZBxrB/rk6jyqo9JS4i5kN18TbmvlKRS/wpjx4xyA6sA3FunkPnJ33BRKq1iD09MnbecTrpxBWP0= generated-by-azure"
}

resource "azurerm_ssh_public_key" "kafka_key" {
  name                = "kafka-vm_key"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnQ+nC7cJquCnqWmt35XZ8v9wH4DhNqjecSIpmarxb+a1M9xgDpjj9s0yF6HJ7jAxHIK+K/3wdzhWGip3+Z0zUjy/so92sp1gwYBsI4cJY5R8hF3ui5rVGah8xngNEbeLkeIBDgTYeNnOZMBKmq2xAnuVWph1VGg8IBMu0jlOigpnbzwtT1eepJmX3BsDNiFPCa0wdftZfrqRIa7aIkx0cpPwTGJPwFOuwGhrgX9t2Dn2QUQvP7YR5KGs15xZbZbJllww/humbhkiMpqQ0r1sl3ke+1Qy3vKhgyfAqULjL6bbQvP0TkNwY96As3HYjTAvV1ZrOIxCpwhe0KtQYMzVl0ZeK01xsmbIu+LwuwHcCZ4HHdD2oL592QLXwpUQJNGNytrtJAkg8RNQrzC1O9+fZXoeR4s0GGxfgbW4JR/Cmkcetb/vTGPfFjnYg57WwR3aCN9rumxmDphSud3LFPyRWC/HDuEh2wynSmqHjEMSOaIkQVQ6zb0+16iv5WzPh1vE= generated-by-azure"
}

############################
# 🌐 NETWORKING PER VM
############################
# NiFi Server NSG + NIC + IP
resource "azurerm_network_security_group" "nifi_nsg" {
  name                = "nifi-server-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_public_ip" "nifi_ip" {
  name                = "nifi-server-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nifi_nic" {
  name                = "nifi-server752_z1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nifi_ip.id
  }
}

# Kafka NSG + NIC + IP
resource "azurerm_network_security_group" "kafka_nsg" {
  name                = "kafka-vm-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_public_ip" "kafka_ip" {
  name                = "kafka-vm-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "kafka_nic" {
  name                = "kafka-vm669_z1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.kafka_ip.id
  }
}

# Decision NSG + NIC + IP
resource "azurerm_network_security_group" "decision_nsg" {
  name                = "Decision-Pulse-Backend-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_public_ip" "decision_ip" {
  name                = "Decision-Pulse-Backend-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "decision_nic" {
  name                = "decision-pulse-backend850_z1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.decision_ip.id
  }
}

############################
# 💻 VMs (All 3)
############################
resource "azurerm_linux_virtual_machine" "nifi_vm" {
  name                  = "nifi-server"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_D8s_v3"
  admin_username        = "new-azureuser"
  network_interface_ids = [azurerm_network_interface.nifi_nic.id]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "new-azureuser"
    public_key = azurerm_ssh_public_key.nifi_key.public_key
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  os_disk {
    name                 = "nifi-server_disk1_6cae24ec2d9341d39f495ba04756c1cb"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  zone = "1"
  secure_boot_enabled = true
  vtpm_enabled        = true
}

resource "azurerm_linux_virtual_machine" "kafka_vm" {
  name                  = "kafka-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_D8s_v3"
  admin_username        = "new-azureuser"
  network_interface_ids = [azurerm_network_interface.kafka_nic.id]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "new-azureuser"
    public_key = azurerm_ssh_public_key.kafka_key.public_key
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  os_disk {
    name                 = "kafka-vm_OsDisk_1_70f998a86e694561932aff7e5aff5e41"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  zone = "1"
  secure_boot_enabled = true
  vtpm_enabled        = true
}

resource "azurerm_linux_virtual_machine" "decision_vm" {
  name                  = "Decision-Pulse-Backend"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_D8ds_v4"
  admin_username        = "new-azureuser"
  network_interface_ids = [azurerm_network_interface.decision_nic.id]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "new-azureuser"
    public_key = azurerm_ssh_public_key.decision_key.public_key
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  os_disk {
    name                 = "Decision-Pulse-Backend_OsDisk_1_9a5ac9f92a584d91b944cac3611fee95"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  zone = "1"
  secure_boot_enabled = true
  vtpm_enabled        = true
}

############################
# 🐘 OPTIONAL: PostgreSQL Flexible Server
############################
# Uncomment if you want to recreate `genflow-postgress`
# resource "azurerm_postgresql_flexible_server" "postgres" {
#   name                   = "genflow-postgress"
#   resource_group_name    = azurerm_resource_group.rg.name
#   location               = azurerm_resource_group.rg.location
#   version                = "13"
#   delegated_subnet_id    = azurerm_subnet.subnet.id
#   administrator_login    = "adminuser"
#   administrator_password = "ReplaceWithStrongPassword!"
#   storage_mb             = 32768
#   sku_name               = "Standard_D2s_v3"
#   zone                   = "1"
# }
