# Example Terraform modules to provision cloud access for Wayfinder

## Usage

1. Initialise a local folder from the relevant module
2. Prepare a `provider.tf` and `terraform.tfvars`
3. Ensure you have access to the relevant cloud account and run `plan` and `apply` using `terraform` or `tofu`

#### AWS
```
terraform init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-aws-wfcloudaccess'
```
```
tofu init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-aws-wfcloudaccess'
```


#### Azure
```
terraform init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-azurerm-wfcloudaccess'
```
```
tofu init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-azurerm-wfcloudaccess'
```

#### GCP
```
terraform init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-google-wfcloudaccess'
```
```
tofu init -from-module='github.com/appvia/wayfinder-cloudaccess//modules/terraform-google-wfcloudaccess'
```
