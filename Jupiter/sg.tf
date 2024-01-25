resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allows http and https inbound traffic to the load balancer"
  vpc_id      = aws_vpc.terraform_vpc.id
  tags = {
    Name = "alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_in" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = var.from_port[0]
  ip_protocol = "tcp"
  to_port     = var.to_port[0]

}


resource "aws_vpc_security_group_ingress_rule" "alb_https_in" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = var.from_port[1]
  ip_protocol = "tcp"
  to_port     = var.to_port[1]

}

resource "aws_vpc_security_group_egress_rule" "alb_https_out" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4 = "0.0.0.0/0"
  #   from_port   = var.from_port[1]
  ip_protocol = "-1"
  #   to_port     = var.to_port[1]
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh-sg"
  description = "Allows ssh inbound traffic from my IP"
  vpc_id      = aws_vpc.terraform_vpc.id
  tags = {
    Name = "ssh-sg"
  }
}

data "http" "myip" {                      # This data resource helps you retrieve your public IP automatically
  url = "https://ipv4.icanhazip.com"
}

resource "aws_vpc_security_group_ingress_rule" "myssh_in" {
  security_group_id = aws_security_group.ssh_sg.id

  cidr_ipv4   = "${chomp(data.http.myip.response_body)}/32"
  from_port   = var.from_port[2]
  ip_protocol = "tcp"
  to_port     = var.to_port[2]

}

resource "aws_vpc_security_group_egress_rule" "myssh_out" {
  security_group_id = aws_security_group.ssh_sg.id

  cidr_ipv4 = "0.0.0.0/0"
  #   from_port   = var.from_port[2]
  ip_protocol = "-1"
  #   to_port     = var.to_port[2]

}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "Allows inbound traffic from the load balancer"
  vpc_id      = aws_vpc.terraform_vpc.id
  tags = {
    Name = "webserver-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "webserver_sg_in" {
  security_group_id            = aws_security_group.webserver_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = var.from_port[0]
  ip_protocol                  = "tcp"
  to_port                      = var.from_port[0]
}

resource "aws_vpc_security_group_ingress_rule" "webserver_sg_1" {
  security_group_id            = aws_security_group.webserver_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = var.from_port[1]
  ip_protocol                  = "tcp"
  to_port                      = var.from_port[1]
}

resource "aws_vpc_security_group_ingress_rule" "webserver_sg_2" {
  security_group_id            = aws_security_group.webserver_sg.id
  referenced_security_group_id = aws_security_group.ssh_sg.id
  from_port                    = var.from_port[2]
  ip_protocol                  = "tcp"
  to_port                      = var.from_port[2]
}

resource "aws_vpc_security_group_egress_rule" "webserver_egress" {
  security_group_id = aws_security_group.webserver_sg.id
  #   referenced_security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  #   from_port   = var.from_port[1]
  ip_protocol = "-1"
  #   to_port     = var.to_port[1]
}