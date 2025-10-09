# Example Terraform modules to provision cloud access for Wayfinder

## Usage

1. Initialise a local folder from the relevant module
2. Prepare a `provider.tf` and `terraform.tfvars`
3. Ensure you have access to the relevant cloud account and run `plan` and `apply` using `terraform` or `tofu`

#### AWS
```
terraform init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-aws-wfcloudaccess'
cp provider.tf.sample provider.tf
```

```
tofu init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-aws-wfcloudaccess'
cp provider.tf.sample provider.tf
```

#### Azure
```
terraform init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-azurerm-wfcloudaccess'
cp provider.tf.sample provider.tf
```

```
tofu init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-azurerm-wfcloudaccess'
cp provider.tf.sample provider.tf
```

#### GCP
```
terraform init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-google-wfcloudaccess'
cp provider.tf.sample provider.tf
```

```
tofu init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-google-wfcloudaccess'
cp provider.tf.sample provider.tf
```

### Prepare `terraform.tfvars`

Create `terraform.tfvars` following the example in `terraform.tfvars.sample` - this will need to be amended for your environment.

### Plan and apply
Ensuring you have access to the target AWS/Azure/GCP account:
```
terraform plan -out tfplan
terraform apply tfplan
```
```
tofu plan -out tfplan
tofu apply tfplan
```
