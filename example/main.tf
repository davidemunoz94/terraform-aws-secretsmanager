data "aws_organizations_organization" "current" {
  provider = aws.mgmt
}

module "credentials" {
  source = ".."
  providers = {
    aws = aws.mgmt
  }

  kms_key_id = data.terraform_remote_state.account-setup.outputs.sm_kms_key_arn

  secrets = [
    {
      secret_name        = "secret_name"                # Update
      secret_description = "Creating test credentials." # Update
    }
  ]

  path                    = "${var.path}credentials/"
  partition               = local.partition
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = local.global_tags

  # Random Password
  password_length = 20

  # Sharing
  shared = false # Update to true and select utilize one of the options below if sharing
  #organization_ids  = [data.aws_organizations_organization.current.id] # Share with Organizations
  #cross_account_ids = [local.root_account_id]                          # Share across AWS Accounts, update local to appropriate account ID
}
