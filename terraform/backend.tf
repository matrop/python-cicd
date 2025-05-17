terraform {
  # TODO: Environment agnostic!
  backend "azurerm" {
    use_oidc             = true
    use_azuread_auth     = true
    storage_account_name = "samauriceatropsdev" # TODO: How to account for different environments?
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
