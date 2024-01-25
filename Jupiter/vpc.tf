resource "aws_vpc" "terraform_vpc" {
  cidr_block           = var.cidr-block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "publicterraform_subnets" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = each.value
  for_each          = var.publicsubnetCidr
  availability_zone = substr(each.key, -3, -1) == "AZ1" ? var.az[0] : var.az[1]
  tags = {
    Name = "${var.vpc-name}-${each.key}"
  }
}

resource "aws_subnet" "privateterraform_subnets" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = each.value
  for_each          = var.privateSubnetcidr
  availability_zone = substr(each.key, -3, -1) == "AZ1" ? var.az[0] : var.az[1]
  tags = {
    Name = "${var.vpc-name}-${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "${var.vpc-name}-igw"
  }
}


resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = var.tags[0]
  }
  route {
    cidr_block = var.PublicRT-Destination
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "pub_acc" {
  for_each       = aws_subnet.publicterraform_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.Public_RT.id
}


resource "aws_eip" "elastic_ip" {
  vpc             = true
  public_ipv4_pool = "amazon"
}



