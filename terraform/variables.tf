###################################
# GitHub OIDC Provider
###################################

variable "create" {
  description = "Whether to create an IAM OpenID Connect provider."
  type        = bool
  default     = true
}

variable "url" {
  description = "The URL of the identity provider."
  type        = string
  default     = ""
}

variable "client_id_list" {
  description = "A list of client IDs (also known as audiences). When a mobile or web app registers with an OpenID Connect provider, they establish a value that identifies the application. This is the value that goes into the ClientID field."
  type        = list(string)
  default     = []
}

variable "additional_thumbprints" {
  description = "A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)."
  type        = list(string)
  default     = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

variable "tags" {
  description = "A mapping of tags to assign to the IAM OpenID Connect provider."
  type        = map(string)
  default     = {}
}

################################################################################
# GitHub OIDC Role
################################################################################

variable "name" {
  description = "Name of IAM role"
  type        = string
  default     = null
}

variable "path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "description" {
  description = "IAM Role description"
  type        = string
  default     = null
}

variable "policies" {
  description = "Policies to attach to the IAM role in `{'static_name' = 'policy_arn'}` format"
  type        = map(string)
  default     = {}
}

variable "force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = null
}

variable "audience" {
  description = "Audience to use for OIDC role. Defaults to `sts.amazonaws.com` for use with the [official AWS GitHub action](https://github.com/aws-actions/configure-aws-credentials)"
  type        = string
  default     = "sts.amazonaws.com"
}

variable "subjects" {
  description = "List of GitHub OIDC subjects that are permitted by the trust policy. You do not need to prefix with `repo:` as this is provided. Example: `['my-org/my-repo:*', 'octo-org/octo-repo:ref:refs/heads/octo-branch']`"
  type        = list(string)
  default     = []
}

variable "provider_url" {
  description = "The URL of the identity provider. Corresponds to the iss claim"
  type        = string
  default     = "token.actions.githubusercontent.com"
}
