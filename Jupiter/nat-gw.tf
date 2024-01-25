
data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["jupiter-terraform-vpc-Public_Subnet_AZ1"]
  }
  depends_on = [aws_subnet.publicterraform_subnets]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = data.aws_subnet.selected.id

  tags = {
    Name = "NAT-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]

}

resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = var.tags[1]
  }
  #   dynamic "route" {
  #     for_each = aws_subnet.privateterraform_subnets

  #     content {
  #       cidr_block     = "0.0.0.0/0"
  #       nat_gateway_id = aws_nat_gateway.nat_gw[each.value.id].id
  #     }
  #   }
  route {
    cidr_block     = var.PublicRT-Destination
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  depends_on = [aws_nat_gateway.nat_gw, aws_subnet.privateterraform_subnets]
}

resource "aws_route_table_association" "private_acc" {
  for_each       = aws_subnet.privateterraform_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.Private_RT.id
}


