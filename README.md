# Terraform Cloud Preview - Demo

## Pre-Requisites

- Clone this repository

- [TF Helper](https://github.com/joatmon08/tf-helper) - using fork
  because there is a missing colon in a bash script

- Terraform 0.12

- Azure & GCP Credentials

## No VCS Provider, Just Remote Plan & Apply

This is similar experience to running Terraform
locally, via CLI.

1. `cd azure`

1. `terraform init -backend-config=backend.conf`

1. Go to Terraform Cloud. You should see the workspace in the console.

1. In General Settings, notice:
   1. The workspace has been created with default remote settings.
   1. Terraform version can be selected.

1. With remote, need to add variables to workspace.

   1. For general variables, you can add them in the UI. `cat
      azure.tfvars`

   1. For secrets & credentials, you can use the API to push them up.
      ```shell
      tfh pushvars -svar client_id=$TF_VAR_client_id \
        -svar client_secret=$TF_VAR_client_secret \
        -svar tenant_id=$TF_VAR_tenant_id \
        -svar subscription_id=$TF_VAR_subscription_id
      ```

1. Run `terraform plan`. Notice that the variables auto-populate and the
   plan output shows the variables we updated on the workspace.

1. Run `terraform apply`. If you go to the console, notice that the plan
   has stopped. It is queued for approval. When I approve on CLI, this
   triggers the approval.

1. To destroy, we need to add the environment variable
   `CONFIRM_DESTROY=1` to the workspace.

## VCS Provider

This integrates a VCS provider and allows us to do pull request
automation.

### Setup Steps

1. Go to Terraform Cloud and click on the Organization's settings.

1. Follow the [VCS integration guide](https://www.terraform.io/docs/cloud/vcs/index.html)
   and set up the VCS provider of your choice.

1. `cd gcp`

1. Let's initialize a workspace. We use a backend configuration that
   contains a workspace prefix, so we need to create and select the
   workspaces.
   ```shell
   terraform init -backend-config=backend.conf
   terraform workspace new production
   terraform workspace select production
   ```

1. Go to Terraform Cloud. You should see the workspace in the console.

1. Set up the workspace to use the VCS provider.

   1. Under Settings -> General, enter the `gcp` working directory.

   1. Under Settings -> Version Control, set up the repository.

1. With remote, need to add variables to workspace.
   ```shell
   tfh pushvars -svar project=$TF_VAR_project \
     -svar credentials="$TF_VAR_credentials" \
     -var region=$TF_VAR_region \
     -var subnet_cidr=$TF_VAR_subnet_cidr \
     -var cluster_name=$TF_VAR_cluster_name
   ```

### Pull Request Automation

1. Create a new branch. `git checkout -b qa`

1. Set up a new workspace. `terraform workspace new qa`

1. Set up the workspace to use the VCS provider.

   1. Under Settings -> General, select "auto-apply" and enter the `gcp`
      working directory.

   1. Under Settings -> Version Control, set up the repository and set
      auto-triggering to always trigger on run.

1. Push up the variables.
   ```shell
   tfh pushvars -svar project=$TF_VAR_project \
     -svar credentials="$TF_VAR_credentials" \
     -var region=$TF_VAR_region \
     -var subnet_cidr=$TF_VAR_subnet_cidr \
     -var cluster_name=$TF_VAR_cluster_name \
     -env-var CONFIRM_DESTROY=1
   ```

1. Push the branch. `git push origin qa`

1. Configure Settings -> Version Control to use the
   branch `qa`.

1. Queue plan to create an environment that mimics production.

1. This branch is currently parity with production in configuration, so we'll
   going to add a new subnet (just as an example).

1. Commit and push to the `qa` branch.

1. Go to the Terraform Cloud console and point out the commit logged and
   trigger by the change.

1. Create a pull request from Github. Within the PR, we see some new checks
   being generated that reference Terraform Cloud.

1. When we merge, it will automatically get added to master.
