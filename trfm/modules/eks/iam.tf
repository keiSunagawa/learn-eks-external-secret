## for Master
resource "aws_iam_role" "eks_master_role" {
  name = "${var.prefix}_eks_master_role"

  assume_role_policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOS
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_master_role.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_master_role.name
}
# resource "aws_iam_role_policy_attachment" "eks_worker_role_farget_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonEKSForFargateServiceRolePolicy"
#   role       = aws_iam_role.eks_master_role.name
# }


# for Worker
resource "aws_iam_role" "eks_worker_role" {
  name               = "${var.prefix}_eks_worker_role"
  assume_role_policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "eks.amazonaws.com",
          "eks-fargate-pods.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOS
}

# fargate
# resource "aws_iam_role_policy_attachment" "eks_worker_role_ecs_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
#   role       = aws_iam_role.eks_worker_role.name
# }

# node group
resource "aws_iam_role_policy_attachment" "eks_worker_role_worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_role_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_role_ecs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_role_cw_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.eks_worker_role.name
}

# resource "aws_iam_instance_profile" "eks_worker_role_profile" {
#   name = "${var.prefix}_eks_worker_profile"
#   role = "${aws_iam_role.eks_worker_role.name}"
# }
