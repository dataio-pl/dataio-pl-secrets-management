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

module "helm_release_reloader" {
  source = "../../modules/helm"

  enabled          = true

  name             = "reloader"
  description      = "Configure Reloader operator"
  namespace        = "utils"
  create_namespace = false
  repository       = "https://stakater.github.io/stakater-charts"
  chart            = "stakater/reloader"
  chart_version    = "1.0.69"
  chart_values     = [<<EOF
reloader:
  namespaceSelector: "reloader=enabled"
  deployment:
    replicaCount: 1
    image:
      repository: ghcr.io/stakater/reloader
      pullPolicy: IfNotPresent
  watchGlobally: true
EOF
]
}
