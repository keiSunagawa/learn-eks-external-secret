resource "aws_eks_fargate_profile" "example" {
  cluster_name           = aws_eks_cluster.main_eks.name
  fargate_profile_name   = "${var.prefix}_fargate"
  pod_execution_role_arn = aws_iam_role.eks_worker_role.arn
  subnet_ids             = [for x in values(var.priv_subnet_items) : x.id]

  selector {
    namespace = "kube-system"
    labels = {
      "k8s-app" = "kube-dns"
    }
  }

  timeouts {
    create = "20m"
    delete = "20m"
  }
}
