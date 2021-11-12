# Desription

This configuration file will create the following gcp resources
 - GCP Project
 - GCP PubSub Topic and Subscription
 - GCP Firestore and a Firestore Document
 - Change the project name and project id to your own
 - You can change the postfix number to different number as it will be used to create different project
 - List of used project ids: terraform-test-nv-1a, terraform-test-nv-1, terraform-test-nv-12, terraform-test-nv-123

 ## Getting Stated
 
 ### Install Terraform


You can use homebrew or download the latest version from [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)

    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform

### Verify Terraform version:  

        terraform -v

### Login to GCP and set application default credentials

    gcloud auth application-default login

### Init Terraform

This will initialize the terraform configuration file and install the required plugins. i.e google-beta

    terraform init

### Plan Terraform

    terraform plan

### Apply Terraform

    terraform apply


# Documentations

## GCP Provider

https://registry.terraform.io/providers/hashicorp/google/latest/docs

## Terraform Lanaguage
Terraform native configuration lanaguage and syntax.

https://www.terraform.io/docs/language/index.html