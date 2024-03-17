module "iam-oidc" {
  source = "../../modules/iam-github-oidc"

  create = true

  url      = "https://token.actions.githubusercontent.com"
  name     = "DataIOSecretsManagerPipelineWithOIDC"
  policies = {
    "GitHubOIDC" = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  }
  subjects = [
    "dataio-pl/secrets-management:*"
  ]
}

provider "aws" {
  region = "eu-central-1"
}