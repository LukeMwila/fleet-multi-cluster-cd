# Microsoft Azure AKS Cluster
This repository contains source code to provision a Kubernetes cluster in Azure using Terraform. 

## Prerequisites
* Azure account
* Azure profile configured with [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) on local machine
* [Terraform](https://www.terraform.io/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Project Structure
```
├── README.md
├── aks
|  ├── cluster.tf
|  └── variables.tf
├── main.tf
└── provider.tf
```

### Authenticate to Azure using the CLI
The next step after installation is to authenticate to Azure, which can be done using the CLI. Run the following command and your default browser will open for you to sign into Azure with a Microsoft account.
```
az login
```
You can then view account details with the following command:
```
az account list
```
This will output something similar to the following:
```
[
  {
    "cloudName": "AzureCloud",
    "id": "00000000-0000-0000-0000-000000000000",
    "isDefault": true,
    "name": "PAYG Subscription",
    "state": "Enabled",
    "tenantId": "00000000-0000-0000-0000-000000000000",
    "user": {
      "name": "user@example.com",
      "type": "user"
    }
  }
]
```
The `id` field is the `subscription_id`. The Subscription ID is a GUID that uniquely identifies your subscription to use Azure services. If you have multiple subscriptions, you can set the one you want to use with the following command:
```
az account set --subscription="SUBSCRIPTION_ID"
```

## Remote Backend State Configuration
To configure remote backend state for your infrastructure, create an S3 bucket and DynamoDB table before running *terraform init*. In the case that you want to use local state persistence, update the *provider.tf* accordingly and don't bother with creating an S3 bucket and DynamoDB table.

### Create S3 Bucket for State Backend
```aws s3api create-bucket --bucket euw1-fleet-multi-cluster-tf-state --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1 ```
*NB: The bucket name you choose should be globally unique. The one specified in this project is already acquired.*

### Create DynamoDB table for State Locking
```aws dynamodb create-table --table-name euw1-fleet-aks-cluster-tf-state --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1```
*NB: State locking is an optimal solution when working in a team.*

## Provision Infrastructure
Review the *main.tf* to update the node size configurations (i.e. desired, maximum, and minimum). When you're ready, run the following commands:
1. `terraform init` - Initialize the project, setup the state persistence (whether local or remote) and download the API plugins.
2. `terraform plan` - Print the plan of the desired state without changing the state.
3. `terraform apply` - Print the desired state of infrastructure changes with the option to execute the plan and provision. 

## Connect to AKS Cluster
Using the same Azure account profile that provisioned the infrastructure, you can connect to your cluster by updating your local kube config with the following command:
```
az aks get-credentials --resource-group <resource-group-name> --name <cluster-name>
```

## View Existing Workloads
`kubectl get pods --all-namespaces`