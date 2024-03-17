variable "create" {
  description = "Create the IAM role and policy"
  type        = bool
  default     = true
}

variable "url" {
  description = "The URL of the OIDC provider"
  type        = string
}

variable "oidc_subjects" {
  description = "The list of subjects to allow"
  type        = list(string)
}

variable "secret_arns" {
  description = "The list of secret ARNs to allow access to"
  type        = list(string)
}

variable "policy_name" {
  description = "The name of the policy"
  type        = string
}

variable "policy_description" {
  description = "The description of the policy"
  type        = string
  default     = null
}

variable "role_name" {
  description = "The name of the role"
  type        = string
}

variable "role_description" {
  description = "The description of the role"
  type        = string
  default     = null
}
