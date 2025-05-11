resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_container_group" "container" {
  name                        = var.container_group_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  ip_address_type             = "Public"
  os_type                     = "Linux"
  restart_policy              = var.container_group_restart_policy
  some_none_existent_property = true

  container {
    name   = var.container_name
    image  = var.container_image
    cpu    = var.container_cpu_cores
    memory = var.container_memory_in_gb

    ports {
      port     = var.container_port
      protocol = "TCP"
    }
  }
}
