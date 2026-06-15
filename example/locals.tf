locals {
  global_tags = {
    Application = "Application Name" # Update as needed
    Owner       = "Platform Team"    # Update as needed
    Team        = "Platform Team"    # Update as needed
    Environment = "prod"             # Update as needed
  }

  mgmt_plane_account_id = "" #Input Client Management Account ID
  root_account_id       = "" #Input Client Root Account ID
}

locals {
  partition = var.is_gov ? "aws-us-gov" : "aws"
  azs       = ["${var.aws_region}a", "${var.aws_region}b"]
}
