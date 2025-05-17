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
- Created managed identity `infra-user-dev`
- Use Federated Identity Credentials to enable OIDC and avoid managing (and rotating) secrets
- Problem: Azure needs exact branch path for credential (no wildcard)
    - Seems to be by design: https://learn.microsoft.com/en-us/answers/questions/2073829/azure-github-action-federated-identity-login-issue
- TODO: Research how OIDC works exactly

**How to manage Terraform state?**
- GitHub has no feature to store the Terraform state like GitLab
- I'll use an Azure Storage Account
- https://developer.hashicorp.com/terraform/language/backend/azurerm#azure-active-directory
