#Importing the ACM

data "aws_acm_certificate" "acm_certificate" {
  domain      = var.certificate_domain_name
  most_recent = true
}

# Target group

resource "aws_lb_target_group" "tf_target_group" {
  name     = "tf-jupiter-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_vpc.id
  health_check {
    enabled = true
    path    = "/index.html"
  }
}


# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  lb_target_group_arn    = aws_lb_target_group.tf_target_group.arn
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_autoscaling_group.web_asg]
}

# Load balancer

resource "aws_lb" "jupiter_lb" {
  name               = "jupiter-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.publicterraform_subnets["Public_Subnet_AZ1"].id,
    aws_subnet.publicterraform_subnets["Public_Subnet_AZ2"].id
  ] 

  lifecycle {
    create_before_destroy = true
  }
}

#Load balancer Lister

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.jupiter_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.acm_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_target_group.arn
  }
}

# HTTP redirection to HTTPS

resource "aws_lb_listener" "front_end_redirect" {
  load_balancer_arn = aws_lb.jupiter_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Creating Route 53 Alias record 

data "aws_route53_zone" "jupiter_r53" {
  name = "myaws2022lab.com."   # replace with your domain name here. Do NOT forget the trailing '.' 
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.jupiter_r53.zone_id
  name    = "jupitar.myaws2022lab.com"            # Choose a record name here. YYY.domain-name
  type    = "A"
  alias {
    name                   = aws_lb.jupiter_lb.dns_name
    evaluate_target_health = true
    zone_id                = aws_lb.jupiter_lb.zone_id
  }
}