variable "kms_key_id" {
  description = "ARN or alias of the KMS key used to encrypt secret values."
  type        = string
}

variable "partition" {
  description = "AWS partition used to construct IAM principal ARNs."
  type        = string
  default     = "aws"
}

variable "path" {
  description = "Path prefix for created secrets."
  type        = string
  default     = "/example/"
}

variable "secrets" {
  description = "Secrets to create."
  type        = list(map(string))
  default = [
    {
      secret_name        = "application"
      secret_description = "Example application secret"
    }
  ]
}

variable "tags" {
  description = "Tags assigned to created secrets."
  type        = map(string)
  default = {
    Environment = "example"
  }
}
