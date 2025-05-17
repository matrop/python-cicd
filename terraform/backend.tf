terraform {
  # TODO: Environment agnostic!
  backend "azurerm" {
    use_oidc             = true
    use_azuread_auth     = true
    tenant_id            = "e5f140b4-77b2-48a0-9775-fe7437c50fa6"
    client_id            = "c3971fe8-fae4-4df5-91f3-4b2e71078ffe"
    storage_account_name = "samauriceatropsdev" # TODO: How to account for different environments?
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
