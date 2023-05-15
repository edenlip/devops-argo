# devops-argo

This repo should be used to manage an EKS infrastructure, that deploy Argo workflow.

##AWS Infrastructure
The Terraform configuration in the repo sets up the following resources on AWS:

* An S3 bucket with server-side encryption and a KMS key.
* An IAM user named: <b>developer-user</b> with limited permissions to the S3 bucket and KMS key.
* A new VPC
* An EKS cluster named devops-test

## Prerequisites
Before running the Terraform configuration, make sure you have the following:

* AWS CLI installed and configured with appropriate credentials.
* Terraform CLI installed on your local machine.

## Deployment steps
1. Initialise the workspace
  ```
    terraform init
  ```
2. Apply the Terraform configuration:
  ```
    terraform apply
  ```

## Argo Workflow
The Argo Workflow defined in the workflow.yaml file performs the following steps:

1. Downloads a random quote from https://thesimpsonsquoteapi.glitch.me/ and saves it to a local file.

2. Extracts the image URL from the quote JSON.

3. Downloads the image and uploads it to the previously created S3 bucket.

## CleanUp
please run 
  ```
    terraform destroy
  ```
  Note: Be cautious when using the destroy command as it will permanently delete the created resources.



  ### In order to follow security best practices, we are using one TF workspace instead of two per the best practice, one for base infra and one for EKS resources.
  