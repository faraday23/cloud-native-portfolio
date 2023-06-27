<!DOCTYPE html>
<html>

<head>
  <title>DevOps Engineer Project</title>
</head>

<body>
  <h1>Situation</h1>
  <p>I was hired as a devops engineer for an online gift shopping company that wanted to create a website using terraform and Kubernetes Service on Azure (AKS). The website needed to store and access data using Azure Storage and run on a scalable and secure Kubernetes cluster using AKS. The website also needed to have a continuous integration and continuous delivery (CI/CD) pipeline using GitHub Actions and Terraform Cloud.</p>

  <h1>Task</h1>
  <p>My task was to use terraform to create and manage Azure Storage accounts, blob containers, and queues for storing and accessing data. I also had to use terraform to create and manage an Azure virtual network with subnets and network security groups for isolating and securing the Kubernetes cluster. I also had to use terraform to create and manage an AKS cluster with nodes, pods, services, deployments, etc. for running the website. I also had to use GitHub Actions and Terraform Cloud to automate the deployment and update of the infrastructure and the website.</p>

  <h1>Action</h1>
  <ol>
    <li>I created a GitHub repository for storing the terraform configuration files and the website code. I also created a Terraform Cloud workspace for storing the terraform state file and executing the terraform commands remotely.</li>
    <li>I created a terraform configuration file for creating an Azure Storage account with three blob containers and one queue. I used the azurerm provider to interact with the Azure API. I used variables, outputs, locals, etc. to parameterize and customize the configuration file. I used for_each to iterate over the blob containers and queue names. I used depends_on to ensure that the storage account was created before the blob containers and queue.</li>
    <li>I created another terraform configuration file for creating an Azure virtual network with two subnets and two network security groups. I used the azurerm provider to interact with the Azure API. I used variables, outputs, locals, etc. to parameterize and customize the configuration file. I used count to create multiple subnets and network security groups. I used data sources to fetch information from existing resources such as resource groups and locations.</li>
    <li>I created another terraform configuration file for creating an AKS cluster with two node pools, one for system pods and one for user pods. I used the azurerm provider to interact with the Azure API. I used variables, outputs, locals, etc. to parameterize and customize the configuration file. I used dynamic blocks to generate node pool configurations based on input variables. I used depends_on to ensure that the virtual network was created before the AKS cluster.</li>
    <li>I created another terraform configuration file for creating Kubernetes resources such as pods, services, deployments, etc. for running the website on the AKS cluster. I used the kubernetes provider to interact with the Kubernetes API. I used variables, outputs, locals, etc. to parameterize and customize the configuration file. I used data sources to fetch information from existing resources such as storage account keys and connection strings.</li>
    <li>I created a GitHub Actions workflow file for triggering the CI/CD pipeline whenever there was a push or pull request event on the GitHub repository. The workflow consisted of four steps: checkout, setup terraform, plan terraform, and apply terraform. The checkout step cloned the GitHub repository to the GitHub runner machine. The setup terraform step installed terraform on the GitHub runner machine and configured it to use Terraform Cloud as a backend.

 The plan terraform step ran terraform plan on each configuration file and outputted the changes that would be made to the infrastructure. The apply terraform step ran terraform apply on each configuration file and applied the changes to the infrastructure.</li>
  </ol>

  <h1>Issue/Problem</h1>
  <p>One of the issues or problems that I faced during the project was how to handle secrets such as storage account keys and connection strings in a secure way. Storing secrets in plain text in configuration files or environment variables can expose them to unauthorized access or leakage. For example, if someone gained access to my GitHub repository or Terraform Cloud workspace, they could see or modify my secrets.</p>

  <h1>Resolution</h1>
  <p>To resolve this issue or problem, I decided to use Azure Key Vault to store and manage my secrets in a secure way. Azure Key Vault is a service that provides secure storage of keys, secrets, certificates, etc. Azure Key Vault has features like encryption at rest, access policies, auditing, etc. that ensure data protection and compliance.</p>
  <p>Using Azure Key Vault has several advantages:</p>
  <ul>
    <li>It reduces the risk of exposing secrets in plain text in configuration files or environment variables.</li>
    <li>It centralizes the management of secrets in one place, making it easier to update or revoke them.</li>
    <li>It integrates with other Azure services and Terraform providers, making it easier to access or reference them.</li>
  </ul>
  <p>To implement Azure Key Vault, I followed these steps:</p>
  <ol>
    <li>I created an Azure Key Vault resource using the azurerm provider in a separate configuration file. I used variables, outputs, locals, etc. to parameterize and customize the configuration file. I used depends_on to ensure that the resource group was created before the key vault.</li>
    <li>I created secrets in the Azure Key Vault using the azurerm provider in the same configuration file. I used for_each to iterate over the secret names and values. I used sensitive to mark the secret values as sensitive, so that they would not be displayed in the terraform output.</li>
    <li>I accessed the secrets from the Azure Key Vault using data sources in the configuration files where they were needed. I used the azurerm provider to fetch the secret values from the key vault. I used the kubernetes provider to create secret resources in the Kubernetes cluster that referenced the secret values from the key vault.</li>
  </ol>

  <h1>Result</h1>
  <p>As a result of my actions, I was able to use terraform to create and manage Azure Storage accounts, blob containers, and queues for storing and accessing data. I was also able to use terraform to create and manage an Azure virtual network with subnets and network security groups for isolating and securing the Kubernetes cluster. I was also able to use terraform to create and manage an AKS cluster with nodes, pods, services, deployments, etc. for running the website. I was also able to use GitHub Actions and Terraform Cloud to automate the deployment and update of the infrastructure and the website. I was also able to use Azure Key Vault to store and manage secrets in a secure way. I received positive feedback from my supervisor and client for my work on the project.</p>
</body>

</html>