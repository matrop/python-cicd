variable "resource_group_name" {
  type        = string
  description = "Name of the resource group in which the project is deployed"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group"
}

variable "container_group_name" {
  type        = string
  description = "Name of the container group which runs the project image"
}

variable "container_group_restart_policy" {
  type        = string
  description = "The behavior of Azure runtime if container has stopped"
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.container_group_restart_policy)
    error_message = "The restart_policy must be one of the following: Always, Never, OnFailure."
  }
}

variable "container_name" {
  type        = string
  description = "Name of the container inside the container group which runs the project image"
}

variable "container_image" {
  type        = string
  description = "Name of the image that should be run"
}

variable "container_cpu_cores" {
  type        = number
  description = "Number of cpu cores the container will have available"
}

variable "container_memory_in_gb" {
  type        = number
  description = "Storage size in GB the container will have available"
}

variable "container_port" {
  type        = number
  description = "Port that the container exposes"
}
