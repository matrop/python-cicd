## Overview
A learning experience for setting up a CI/CD pipeline for Python

## ToDo
- Create (separate?) pipeline to run continuous delivery on newly setup infrastructure
- Check remaining TODO comments
- Add project documentation

## Infrastructure

*In a real-world use case, one would seperate at least three environments of infrastructure: development, staging and production. This separation was out of the scope of this sample project. However, I showed how a possible separation could look like, e.g. with different .tfvar files.*

TODO: Infrastructure Sketch

**Requirements**

For simplicity, I assumed that some resources are already present and did not automate the creation of them. I decided that this was out of scope of this sample project. Here are the (manual) steps you need to take in order to setup the project in Azure. This can be done either in the Azure Portal or via the Azure CLI:

- Create a resource group (To contain all Azure resources associated with this repository)
- Create a storage account and container inside this resource group (To store Terraform state file)
- Create a user-managed identity
- Give the user-managed identity the following privileges:
    - `Storage Blob Contributor` on the Storage Account Container (To read and write the Terraform state file)
    - `Contributor` on the resource group (To add, change, and delete resources in it via Terraform)
- Create a federated credential for the main branch of your forked repository
    - E.g. I created one with the following subject for the original repository: `repo:matrop/python-cicd:ref:refs/heads/main`

**Open ID Connect**

We use Open ID Connect (OIDC) in order to authenticate Terraform to Azure and provision resources. The usage of OIDC instead of client-secret-based authentication has several advantages:
- We do not need to store credentials in Azure or the CI/CD pipelines. They are requested automatically
- Credentials are short-lived and we do not need to rotate them
- Credentials are granular and enable a detailed access concept

One downside with this is the lack of wildcards in the subject identifier, e.g. for branch names. I read about it [here](https://learn.microsoft.com/en-us/answers/questions/2073829/azure-github-action-federated-identity-login-issue). In a real-world use case where many different tags or branches, e.g. feature branches, would make and apply infrastructure changes, this would be an issue.
