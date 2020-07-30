output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "inter_sg_id" {
  value = aws_security_group.kerfume_security_group["internal_sg"].id
}

output "pud_subnet_items" {
  value = aws_subnet.pub_subns
}

output "priv_subnet_items" {
  value = aws_subnet.priv_subns
}
