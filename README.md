## Overview

In this project I created my first GitHub Actions pipelines to deploy a Python application. I created a simple API using FastAPI, setup Terraform scripts for an Azure Container Instances resource and implemented CI/CD pipelines to orchestrate the deployment of both. The result is an API that is automatically tested and deployed to Azure, where it is publically accessible.

In the CI/CD pipelines I use several tools to ensure code quality and security standards for both the Python and Terraform code. Examples of these tools are PyTest, MyPy, Bandit and Trivy.

The Python API uses FastAPI and is very simple, as the main focus of the repository is the deployment via GitHub Actions.

### Architecture

![Architecture Overview](images/simple-monitoring-stack-architecture.png)

TODO: Infrastructure Sketch
TODO: List and explain GitHub Action Pipelines

For more detailed info see [Infrastructure README](terraform/README.md).

---

The main focus is the deployment of a simple API into the cloud. Therefore I chose tools, which I was most familiar with and that get the job done:

- API: FastAPI was a natural choice since I worked with it in the past. In addition, its documentation and user base is really large, which helped me with research when I got stuck along the way. Another popular choice here would be Flask.
- Infrastructure: Terraform is ubiquitous as a IaC tool. As industry standard, I chose to use it here. Alternatives would be OpenTofu or ARM Templates.
- Docker Image Security: I chose Trivy here, since it seems to be the most widely used application to scan Docker images for vulnerability. I also saw it in a couple of work projects and wanted to try it out.
- Azure Container Instances (ACI): As my deployment artefact is a Docker Image, I needed an Azure service to deploy it. ACI is the most lightweight solution for this in Azure. Alternatives would be Azure Kubernetes Service or Azure Virtual Machines.


## Prerequisites

I used the following Docker (Compose) versions to run this project:

- Docker version 28.1.0, build 4d8c241

## How to Run This Project

You need some external accounts (Dockerhub, Azure) and their secrets. In addition, I did not automate the whole Azure setup, meaning there is minimal setup work required in order to run the project. Please see the [Infrastructure README](./terraform/README.md) for detailed instructions.

1. Fork this repository
2. Run the GitHub Actions pipeline `Continuous Integration`
3. Run the GitHub Actions pipeline `Create Infrastructure Pipeline`
4. See the output of the `Terraform Apply` step `Create Infrastructure Pipelnie` for the IP of the deployed container
5. Type `http://CONTAINER_IP:8080/docs` (replace CONTAINER_IP by the IP address from step 4) in your browser to access the API docs

## Limitations

TODO: More details

- Missing environments
- No real separation between CD and infrastructure pipeline
- Automatic version bumping of Python application
- Destruction pipeline is just for debugging

## Lessons Learned

TODO: Lessons

---

I learned a lot about application monitoring and observability in general. During my research I got more familiar with the three types of signals (metrics, logs and traces) and what questions they answer in a production environment ("Is something happening", "What is happening?", "Where is it happening?"). I feel like I understand the necessity for extensive monitoring now, since without it an application is just a black-box. If it works then all is well, but if it doesn't, it gets frustrating rapidly.

On a technical level I learned the most about OpenTelemetry. Before this project it was just a buzzword to me, but now that I've worked with it, I can explain why it's useful and why it should be implemented in production environments. I found out about receivers, exporters, collectors and other terms. In addition, I could create a mental model for myself how OpenTelemtry, Grafana and signal backends like Loki work together in an observability stack.

I feel I could repeat this project and try to be more independent from the Grafana stack by using Zipkin, Jaeger, FluentD, and others. Due to time constraints and scope, I chose to stay with the Grafana ecosystem for this one.

A big shoutout to GitHub user `autophagy` for providing detailed explanations on how to setup OpenTelemetry in Python: https://github.com/autophagy/pycon-2025-otel-workshop?tab=readme-ov-file#section-3-tracing
