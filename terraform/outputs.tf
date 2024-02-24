################################################################################
# GitHub OIDC Provider
################################################################################

output "oidc_provider_arn" {
  description = "The ARN assigned by AWS for this provider"
  value       = try(aws_iam_openid_connect_provider.this[0].arn, null)
}

output "oidc_provider_url" {
  description = "The URL of the identity provider"
  value       = try(aws_iam_openid_connect_provider.this[0].url, null)
}

################################################################################
# GitHub OIDC Role
################################################################################

output "oidc_role_arn" {
  description = "ARN of IAM role"
  value       = try(aws_iam_role.this[0].arn, null)
}

output "oidc_role_name" {
  description = "Name of IAM role"
  value       = try(aws_iam_role.this[0].name, null)
}

output "oidc_role_path" {
  description = "Path of IAM role"
  value       = try(aws_iam_role.this[0].path, null)
}

output "oidc_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = try(aws_iam_role.this[0].unique_id, null)
}
