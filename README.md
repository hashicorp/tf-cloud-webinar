# Terraform Cloud Preview - Demo

## No VCS Provider, Just Remote Plan & Apply
1. `cd azure`

1. `terraform init -backend-config=backend.conf`

1. `terraform workspace new azure`

1. Go to Terraform Cloud. You should see the workspace in the console.

1. `terraform workspace select azure`

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

### Setup Steps

1. `cd gcp`

1. Go into the organization's settings and add a VCS provider.

1. Let's initialize a workspace that is explicitly defined in name. This
   means that it will not automatically prefix it. `terraform init -backend-config=backend.conf`

1. Go to Terraform Cloud. You should see the workspace in the console.

1. With remote, need to add variables to workspace.
   ```shell
   tfh pushvars -svar project=$TF_VAR_project \
     -svar credentials="$TF_VAR_credentials" \
     -var region=$TF_VAR_region \
     -var subnet_cidr=$TF_VAR_subnet_cidr \
     -var cluster_name=$TF_VAR_cluster_name
   ```

1. Set up the workspace to use the VCS provider.

   1. Under Settings -> Version Control, choose Github and select the
      repository.

   1. Under Settings -> General, select "auto-apply" and enter the `gcp`
      working directory.

   1. Under Settings -> Version Control, set auto-triggering to always trigger
      on run.

1. Branch and open a PR. `git checkout -b disable-http-lb`

1. Set up a new workspace. `terraform workspace new disable-http-lb`

1. Push up the variables.
   ```shell
   tfh pushvars -svar project=$TF_VAR_project \
     -svar credentials="$TF_VAR_credentials" \
     -var region=$TF_VAR_region \
     -var subnet_cidr=$TF_VAR_subnet_cidr \
     -var cluster_name="disable-http-lb" \
     -env-var CONFIRM_DESTROY=1
   ```

1. Run plan to create an environment that mimics production.

### Actual Demo

1. Walk through setting up the workspace to use the VCS provider.

   1. Under Settings -> Version Control, choose Github and select the
      repository.

   1. Under Settings -> General, select "auto-apply" and enter the `gcp`
      working directory.

   1. Under Settings -> Version Control, set auto-triggering to always trigger
      on run.

1. Branch and open a PR. `git checkout -b some-feature`

1. Set up a new workspace. `terraform workspace new some-feature`

1. Push up the variables. Point out `CONFIRM_DESTROY`.
   ```shell
   tfh pushvars -svar project=$TF_VAR_project \
     -svar credentials="$TF_VAR_credentials" \
     -var region=$TF_VAR_region \
     -var subnet_cidr=$TF_VAR_subnet_cidr \
     -var cluster_name="some-feature" \
     -env-var CONFIRM_DESTROY=1
   ```

1. Since this takes a long time, let's switch to a branch we've already prepared.
   `git checkout disable-http-lb`

1. This branch is currently parity with production in configuration, so we'll
   going to disable HTTP load balancing to test the configuration change.
   Update `cluster.tf`.

1. Commit and push to the `disable-http-lb` branch.

1. Go to the Terraform Cloud console and point out the commit logged and
   trigger by the change.

1. Create a pull request from Github. Within the PR, we see some new checks
   being generated that reference Terraform Cloud.

1. 