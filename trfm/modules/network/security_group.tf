locals {
  security_groups = {
    "internal_sg" = {
      "ingress" = {
        "self_all_allowed" = {
          "from_port"   = 0,
          "to_port"     = 0,
          "protocol"    = "-1",
          "self"        = true,
          "cidr_blocks" = []
        }
      },
      "egress" = {
        "all_allowed" = {
          "from_port"   = 0,
          "to_port"     = 0,
          "protocol"    = "-1",
          "self"        = false,
          "cidr_blocks" = ["0.0.0.0/0"]
        }
      }
    }
  }
}
resource "aws_security_group" "kerfume_security_group" {
  for_each = local.security_groups

  name        = "${var.prefix}_${each.key}"
  description = "internall access all allowed."

  tags = {
    Name = "${var.prefix}_${each.key}"
  }

  vpc_id = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      self        = ingress.value.self
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress

    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      self        = egress.value.self
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}
