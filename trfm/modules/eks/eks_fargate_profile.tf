# resource "aws_eks_fargate_profile" "example" {
#   cluster_name           = aws_eks_cluster.main_eks.name
#   fargate_profile_name   = "${var.prefix}_fargate"
#   pod_execution_role_arn = aws_iam_role.eks_worker_role.arn
#   subnet_ids             = [for x in values(var.priv_subnet_items) : x.id]

#   selector {
#     namespace = "kube-system"
#     labels = {
#       "k8s-app" = "kube-dns"
#     }
#   }

#   timeouts {
#     create = "20m"
#     delete = "20m"
#   }
# }

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.main_eks.name
  node_group_name = "${var.prefix}_ng"
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  subnet_ids      = [for x in values(var.priv_subnet_items) : x.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  # # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_role_worker_policy,
    aws_iam_role_policy_attachment.eks_worker_role_cni_policy,
    aws_iam_role_policy_attachment.eks_worker_role_ecs_policy,
    aws_iam_role_policy_attachment.eks_worker_role_cw_policy,
  ]
}
