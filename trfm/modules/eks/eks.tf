locals {
  cluster_name = "${var.prefix}_main_eks"
}

data "template_file" "kubectl_config" {
  # see https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/create-kubeconfig.html
  template = "${file("${path.module}/kube.config.tpl.yml")}"

  vars = {
    endpoint     = "${aws_eks_cluster.main_eks.endpoint}"
    certificate  = "${aws_eks_cluster.main_eks.certificate_authority.0.data}"
    cluster_name = "${local.cluster_name}"
  }
}

resource "aws_eks_cluster" "main_eks" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_master_role.arn
  version  = "1.14"

  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = false
    subnet_ids = concat(
      [for x in values(var.pud_subnet_items) : x.id],
      [for x in values(var.priv_subnet_items) : x.id],
    )
    security_group_ids = [aws_security_group.eks_master_pub_api_sg.id, var.inter_sg_id]
  }
}
