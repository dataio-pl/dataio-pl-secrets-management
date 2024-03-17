locals {
  cluster_name = "eks-cluster"
}

#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster
# Retrieve information about an EKS Cluster
#
data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth
# Get an authentication token to communicate with an EKS cluster
#
data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

module "helm_release_external-secret" {
  source = "../../modules/helm"

  enabled          = true

  name             = "external-secret"
  description      = "Configure External Secrets operator"
  namespace        = "utils"
  create_namespace = false
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secret"
  chart_version    = "0.9.13"
  chart_values     = [<<EOF
replicaCount: 1
image:
  repository: ghcr.io/external-secrets/external-secrets
  pullPolicy: IfNotPresent
installCRDs: true
EOF
]
}
