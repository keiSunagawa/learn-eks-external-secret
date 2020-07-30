locals {
  pub_params = {
    "ap-northeast-1a" = { cidr = "172.30.1.0/24" },
    "ap-northeast-1c" = { cidr = "172.30.2.0/24" }
  }

  priv_params = {
    "ap-northeast-1a" = { cidr = "172.30.3.0/24" },
    "ap-northeast-1c" = { cidr = "172.30.4.0/24" }
  }
}
resource "aws_subnet" "pub_subns" {
  for_each          = local.pub_params
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.key

  tags = {
    Name                                           = "${var.prefix}_pub_subnet_${each.key}"
    "kubernetes.io/cluster/kerfume-local_main_eks" = "shared"
  }
}

resource "aws_route_table_association" "pub_ascs" {
  for_each       = aws_subnet.pub_subns
  subnet_id      = each.value.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_subnet" "priv_subns" {
  for_each          = local.priv_params
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.key

  tags = {
    Name                                           = "${var.prefix}_priv_subnet_${each.key}"
    "kubernetes.io/cluster/kerfume-local_main_eks" = "shared"
  }
}

resource "aws_route_table_association" "priv_ascs" {
  for_each       = aws_subnet.priv_subns
  subnet_id      = each.value.id
  route_table_id = aws_route_table.priv_nat.id
}
