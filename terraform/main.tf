resource "azurerm_container_group" "container" {
  name                = var.container_group_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"
  restart_policy      = var.container_group_restart_policy

  container {
    name   = var.container_name
    image  = "${var.dockerhub_username}/${var.container_image}"
    cpu    = var.container_cpu_cores
    memory = var.container_memory_in_gb

    ports {
      port     = var.container_port
      protocol = "TCP"
    }
  }
}
