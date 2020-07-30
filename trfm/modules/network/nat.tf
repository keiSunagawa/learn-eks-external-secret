resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "${var.prefix}-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  depends_on    = [aws_subnet.pub_subns]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subns["ap-northeast-1a"].id
  tags = {
    Name = "${var.prefix}-nat"
  }
}
