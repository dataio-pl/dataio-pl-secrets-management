# secrets-management

The repository contains the Terraform code which creates the OIDC Provider, IAM roles, and policies to manage the secrets in AWS Secrets Manager.

This might be used by the GitHub Actions to create the secrets in AWS Secrets Manager and then use them in the deployment process.

## GitHub Actions Usage

To run the GitHub Actions Pipeline you should first create the **Repository Secret**. Then use the **Actions** button (blocked in this repository) and fill the form with the following content as in the example below:

![GitHub Actions User Access](./assets/githubactions_useraccess.png)

## Terraform Usage

```hcl
module "secrets_management" {
  source = "terraform"

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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.38.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_thumbprints"></a> [additional\_thumbprints](#input\_additional\_thumbprints) | A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s). | `list(string)` | <pre>[<br>  "6938fd4d98bab03faadb97b34396831e3780aea1",<br>  "1c58a3a8518e8759bf075b76b750d4f2df264fcd"<br>]</pre> | no |
| <a name="input_audience"></a> [audience](#input\_audience) | Audience to use for OIDC role. Defaults to `sts.amazonaws.com` for use with the [official AWS GitHub action](https://github.com/aws-actions/configure-aws-credentials) | `string` | `"sts.amazonaws.com"` | no |
| <a name="input_client_id_list"></a> [client\_id\_list](#input\_client\_id\_list) | A list of client IDs (also known as audiences). When a mobile or web app registers with an OpenID Connect provider, they establish a value that identifies the application. This is the value that goes into the ClientID field. | `list(string)` | `[]` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create an IAM OpenID Connect provider. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | IAM Role description | `string` | `null` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Whether policies should be detached from this role when destroying | `bool` | `true` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum CLI/API session duration in seconds between 3600 and 43200 | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of IAM role | `string` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | Path of IAM role | `string` | `"/"` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | Policies to attach to the IAM role in `{'static_name' = 'policy_arn'}` format | `map(string)` | `{}` | no |
| <a name="input_provider_url"></a> [provider\_url](#input\_provider\_url) | The URL of the identity provider. Corresponds to the iss claim | `string` | `"token.actions.githubusercontent.com"` | no |
| <a name="input_subjects"></a> [subjects](#input\_subjects) | List of GitHub OIDC subjects that are permitted by the trust policy. You do not need to prefix with `repo:` as this is provided. Example: `['my-org/my-repo:*', 'octo-org/octo-repo:ref:refs/heads/octo-branch']` | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the IAM OpenID Connect provider. | `map(string)` | `{}` | no |
| <a name="input_url"></a> [url](#input\_url) | The URL of the identity provider. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The ARN assigned by AWS for this provider |
| <a name="output_oidc_provider_url"></a> [oidc\_provider\_url](#output\_oidc\_provider\_url) | The URL of the identity provider |
| <a name="output_oidc_role_arn"></a> [oidc\_role\_arn](#output\_oidc\_role\_arn) | ARN of IAM role |
| <a name="output_oidc_role_name"></a> [oidc\_role\_name](#output\_oidc\_role\_name) | Name of IAM role |
| <a name="output_oidc_role_path"></a> [oidc\_role\_path](#output\_oidc\_role\_path) | Path of IAM role |
| <a name="output_oidc_role_unique_id"></a> [oidc\_role\_unique\_id](#output\_oidc\_role\_unique\_id) | Unique ID of IAM role |

