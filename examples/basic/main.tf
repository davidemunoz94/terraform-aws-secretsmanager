module "secretsmanager" {
  source = "../.."

  kms_key_id = var.kms_key_id
  partition  = var.partition
  path       = var.path
  secrets    = var.secrets
  tags       = var.tags
}

output "secret_arns" {
  value = module.secretsmanager.secret_arns
}

output "names" {
  value = module.secretsmanager.names
}
