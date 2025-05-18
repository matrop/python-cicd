terraform {
  backend "azurerm" {
    use_oidc             = true
    use_azuread_auth     = true
    storage_account_name = "samauriceatropsdev" # This would need to be environment-specific
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
