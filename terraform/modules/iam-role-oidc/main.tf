data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  url        = replace(var.url, "https://", "")
}

####################################################
# OIDC Role Trust Policy
####################################################

data "aws_iam_policy_document" "assume_role_with_oidc" {
  count = var.create ? 1 : 0

  statement {
    sid     = "SAOidcAuth"
    effect  = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${local.account_id}:oidc-provider/${local.url}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.url}:sub"
      values   = var.oidc_subjects
    }
  }
}

####################################################
# AWS Secrets Manager Access
####################################################

data "aws_iam_policy_document" "external_secrets" {
  count = var.create ? 1 : 0

  statement {
    actions   = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = var.secret_arns
  }
}

####################################################
# IAM Role and Policy Attachments
####################################################

resource "aws_iam_policy" "external_secrets" {
  count = var.create ? 1 : 0

  name        = var.policy_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.external_secrets[0].json
}

resource "aws_iam_role_policy_attachment" "external_secrets" {
  count = var.create ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.external_secrets[0].arn
}

resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

  name               = var.role_name
  description        = var.role_description
  assume_role_policy = data.aws_iam_policy_document.assume_role_with_oidc[0].json
}
