# terraform-aws-secretsmanager

## Description

This repository contains a Terraform module to create and manage secrets in AWS Secrets Manager. It supports the creation of secrets with random or static values and secure access through IAM policies. The variable `names` is a list that will be used to create secrets for however many values are passed into the list.

## Dependencies

No dependencies.

## Resource List

- Secrets Manager Secret (e.g. username and/or password)
- Secret Policy
- Secret Version

## Usage

The below examples demonstrate how you can call the AWS Secrets Manager module to create secrets as needed. 


```hcl
data "aws_organizations_organization" "current" {
  provider = aws.mgmt
}

module "credentials" {
  source = "./aws-secretsmanager"
  providers = {
    aws = aws.mgmt
  }

  kms_key_id = data.terraform_remote_state.account-setup.outputs.sm_kms_key_arn 

  secrets = [
    {
      secret_name        = "svc_paktesting"
      secret_description = "Creating test credentials for Pak Parties."
    }
  ]

  path                    = "${var.path}credentials/"
  partition               = local.partition
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = local.global_tags

  # Random Password
  password_length = 20

  # Sharing
  shared = false #update to true and select utilize one of the options below
  #organization_ids  = [data.aws_organizations_organization.current.id] # Share with Organizations
  #cross_account_ids = [local.root_account_id]                          # Share across AWS Accounts, update local. to appropriate account ID
}
```

## Environment Setup

Establish a secure connection to the Management AWS account used for the build:

```hcl
IAM user authentication:

- Download and install the AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Log into the AWS Console and create AWS CLI Credentials (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- Configure the named profile used for the project, such as 'aws configure --profile example-mgmt'

SSO-based authentication (via IAM Identity Center SSO):

- Login to the AWS IAM Identity Center console, select the permission set for MGMT, and select the 'Access Keys' link.
- Choose the 'IAM Identity Center credentials' method to get the SSO Start URL and SSO Region values.
- Run the setup command 'aws configure sso --profile example-mgmt' and follow the prompts.
- Verify you can run AWS commands successfully, for example 'aws s3 ls --profile example-mgmt'.
- Run 'export AWS_PROFILE=example-mgmt' in your terminal to use the specific profile and avoid having to use '--profile' option.
```

## Deployment Steps

1. Navigate to the Terraform project and create a parent directory in the upper level code, for example:

    ```hcl
    ../aws/terraform/{REGION}/management-account/example
    ```

   If multi-account management plane:

    ```hcl
    ../aws/terraform/{REGION}/{ACCOUNT_TYPE}-mgmt-account/example
    ```

2. Create a new branch. The branch name should provide a high level overview of what you're working on.  

3. Create a properly defined main.tf file via the template found under 'Usage' while adjusting tfvars as needed. Note that many provided variables are outputs from other modules. Example parent directory:

   ```hcl
   ├── Example/
   │   ├── prefix.auto.tfvars   
   │   ├── locals.tf
   │   ├── main.tf
   │   ├── outputs.tf
   │   ├── providers.tf
   │   ├── README.md
   │   ├── remote-data.tf
   │   ├── variables.tf
   │   ├── ...
   ```

4. Change directories to the `secretsmanager` directory.

5. Ensure that the `prefix.auto.tfvars` variables are correct (especially the profile) or create a new tfvars file with the correct variables

6. Customize code to meet requirements

7. From the `secretsmanager` directory run, initialize the Terraform working directory:
   ```hcl
   terraform init
   ```

8. Standardized formatting in code:
   ```hcl
   terraform fmt
   ```

9. Optional: Ensure proper syntax and "spell check" your code:
   ```hcl
   terraform validate
   ```
   
10. Create an execution plan and verify everything looks correct:
      ```hcl
      terraform plan
      ```

11. Apply the configuration:
      ```hcl
      terraform apply
      ```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_iam_policy_document.resource_policy_MA](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_secretsmanager_random_password.random_passwords](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_random_password) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cross_account_ids"></a> [cross\_account\_ids](#input\_cross\_account\_ids) | A list of strings containing the account IDs of AWS accounts that should have cross-account access to this secret | `list(string)` | `[]` | no |
| <a name="input_empty_value"></a> [empty\_value](#input\_empty\_value) | Whether the secret should be generated without a value | `bool` | `false` | no |
| <a name="input_exclude_characters"></a> [exclude\_characters](#input\_exclude\_characters) | String of the characters that you don't want in the password | `string` | `"\" # $ % & ' ( ) * + , . / : ; < = > ? @ [ \\ ] ^ ` { \| } ~" | no |
| <a name="input_exclude_lowercase"></a> [exclude\_lowercase](#input\_exclude\_lowercase) | Specifies whether to exclude lowercase letters from the password | `bool` | `false` | no |
| <a name="input_exclude_numbers"></a> [exclude\_numbers](#input\_exclude\_numbers) | Specifies whether to exclude numbers from the password | `bool` | `false` | no |
| <a name="input_exclude_punctuation"></a> [exclude\_punctuation](#input\_exclude\_punctuation) | Specifies whether to exclude punctuation characters from the password: ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ \_ ` { | } ~` | `bool` | `false` | no |
| <a name="input_exclude_uppercase"></a> [exclude\_uppercase](#input\_exclude\_uppercase) | Specifies whether to exclude uppercase letters from the password | `bool` | `false` | no |
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | a map of strings that contains global level tags | `map(string)` | `{}` | no |
| <a name="input_include_space"></a> [include\_space](#input\_include\_space) | Specifies whether to include the space character | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Specifies the ARN or alias of the AWS KMS customer master key (CMK) to be used to encrypt the secret values in the versions stored in this secret. | `string` | n/a | yes |
| <a name="input_organization_ids"></a> [organization\_ids](#input\_organization\_ids) | The AWS Organization ID to share secrets with. If specified, cross\_account\_ids will be ignored | `list(string)` | `[]` | no |
| <a name="input_partition"></a> [partition](#input\_partition) | The AWS partition to use | `string` | n/a | yes |
| <a name="input_password_length"></a> [password\_length](#input\_password\_length) | Length of the password | `number` | `15` | no |
| <a name="input_path"></a> [path](#input\_path) | Path to organize secrets | `string` | n/a | yes |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | Number of days that AWS Secrets Manager waits before it can delete the secret. | `number` | `30` | no |
| <a name="input_regional_tags"></a> [regional\_tags](#input\_regional\_tags) | a map of strings that contains regional level tags | `map(string)` | `{}` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | List of regions to replicate the secret to. Each replica can optionally specify a KMS key | <pre>list(object({<br/>    region      = string<br/>    kms_key_arn = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_require_each_included_type"></a> [require\_each\_included\_type](#input\_require\_each\_included\_type) | Specifies whether to include at least one upper and lowercase letter, one number, and one punctuation | `bool` | `true` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Specifies the friendly name of the new secrets to be created as key and an optional value field for descriptions | `list(map(string))` | n/a | yes |
| <a name="input_shared"></a> [shared](#input\_shared) | Whether secrets should be shared across accounts. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_names"></a> [names](#output\_names) | Returns list of secret names to be created. |
| <a name="output_path"></a> [path](#output\_path) | Path to secret values |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | The ARN values of the generated secrets |
| <a name="output_secret_iam_policy_doc_json"></a> [secret\_iam\_policy\_doc\_json](#output\_secret\_iam\_policy\_doc\_json) | JSON doc of the policy output to use on roles if desired |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | Returns all secrets generated by the secrets manager module |
<!-- END_TF_DOCS -->

## Contributing

[Start Here](CONTRIBUTING.md)

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

## Tree
```
.
|-- CHANGELOG.md
|-- CONTRIBUTING.md
|-- LICENSE
|-- README.md
|-- example
|   |-- locals.tf
|   |-- main.tf
|   |-- outputs.tf
|   |-- providers.tf
|   |-- remote-data.tf
|   |-- sm.auto.tfvars
|   |-- variables.tf
|-- main.tf
|-- outputs.tf
|-- release-please-config.json
|-- required_providers.tf
|-- variables.tf
```
