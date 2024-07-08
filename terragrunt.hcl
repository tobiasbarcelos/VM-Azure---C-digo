terraform {
  source = "./modules/modulos"
}
inputs = {
  resource_group_name = "rg-testvm-terraform"
  location            = "eastus"
  vnet1_name          = "myVnet1"
  vnet2_name          = "myVnet2"
  vnet1_address_space = "10.0.0.0/16"
  vnet2_address_space = "10.1.0.0/16"
  subnet_name         = "mySubnet"
  bastion_subnet_name = "AzureBastionSubnet"
  bastion_subnet_id   = "ID_DO_SUBNET_BASTION"
  vm_name             = "VMTestTerraform"
  vm_size             = "Standard_B2ms"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234!"
  vnet2_resource_group_name = "existing-resource-group-vnet2"
  domain_name         = "midelinx.com.br"
  domain_username     = "tobias_barcelos@midelinx.com.br"
  domain_password     = "Vwn7CuhUr4726wQ1"
}
