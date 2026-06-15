# Basic Example

This example creates a generated secret using the local `aws-secretsmanager` module.

## Run

```sh
cp terraform.tfvars.example terraform.tfvars
# Replace every REPLACE_ME value.
terraform init
terraform validate
terraform plan
```

Review the plan before applying it. The generated secret value is stored in Terraform state.
