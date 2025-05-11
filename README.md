## Overview
A learning experience for setting up a CI/CD pipeline for Python

## ToDo
- Create Terraform scripts to deploy Docker image on Azure
- Create pipeline to setup infrastructure using Terraform scripts
- Create (separate?) pipeline to run continuous delivery on newly setup infrastructure
- Check remaining TODO comments
- Add project documentation

## Infrastructure

Source: https://learn.microsoft.com/en-us/azure/container-instances/container-instances-quickstart-terraform

**How to manage Terraform state?**
- GitHub has no feature to store the Terraform state like GitLab
- I'll use an Azure Storage Account