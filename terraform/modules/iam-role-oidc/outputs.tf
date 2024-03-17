output "iam_role_arn" {
  description = "The ARN of the IAM role"
  value       = try(aws_iam_role.this[0].arn, null)
}

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = try(aws_iam_role.this[0].name, null)
}
