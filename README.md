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

### Actual Demo

1. Update the workspace to use the VCS provider.

   1. Under Settings -> Version Control, choose Github and select the
      repository.

   1. Under Settings -> General, select the `gcp` working directory.

1. Branch and open a PR. Edit the number of clusters you want, for example.

1. Push a commit.

1. Watch the plan run. Approve and apply!

