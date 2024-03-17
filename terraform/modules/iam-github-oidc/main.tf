data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  create_provider = var.create && var.url != null
  account_id      = data.aws_caller_identity.current.account_id
  partition       = data.aws_partition.current.partition
  provider_url    = replace(var.provider_url, "https://", "")
}

####################################################
# OIDC Provider
####################################################

data "tls_certificate" "this" {
  count = local.create_provider ? 1 : 0

  url = var.url
}

resource "aws_iam_openid_connect_provider" "this" {
  count = local.create_provider ? 1 : 0

  url             = var.url
  client_id_list  = coalescelist(var.client_id_list, ["sts.${data.aws_partition.current.dns_suffix}"])
  thumbprint_list = distinct(concat(data.tls_certificate.this[0].certificates[*].sha1_fingerprint, var.additional_thumbprints))

  tags = var.tags
}

####################################################
# OIDC Role Trust Policy
####################################################

data "aws_iam_policy_document" "this" {
  count = var.create ? 1 : 0

  statement {
    sid     = "GithubOidcAuth"
    effect  = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:oidc-provider/${local.provider_url}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.provider_url}:aud"
      values   = [var.audience]
    }

    condition {
      test     = "StringLike"
      variable = "${local.provider_url}:sub"
      values   = [for subject in var.subjects : "repo:${trimprefix(subject, "repo:")}"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

  name        = var.name
  path        = var.path
  description = var.description

  assume_role_policy    = data.aws_iam_policy_document.this[0].json
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in var.policies : k => v if var.create }

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}
