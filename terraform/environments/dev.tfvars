resource_group_name     = "mauriceatrops-dev"
resource_group_location = "westeurope"

container_group_name           = "maurice-sample-container-group-dev"
container_group_restart_policy = "Always"

container_name         = "python-cicd-container"
container_image        = "python-cicd"
container_cpu_cores    = 1
container_memory_in_gb = 1
container_port         = 8080
