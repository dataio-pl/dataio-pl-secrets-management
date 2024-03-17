module "iam-oidc" {
  source = "../../../modules/iam-role-oidc"

  create = true

  url           = "oidc.eks.eu-central-1.amazonaws.com/id/EEC311A801556031086B6AE005683618"
  oidc_subjects = [
    "system:serviceaccount:utils:eso-sa"
  ]
  secret_arns   = [
    "arn:aws:secretsmanager:eu-central-1:962491557115:secret:aws/dev/rds/access*"
  ]
  policy_name   = "eso-dev-eks-policy"
  role_name     = "eso-dev-eks-role"
}

provider "aws" {
  region = "eu-central-1"
}
