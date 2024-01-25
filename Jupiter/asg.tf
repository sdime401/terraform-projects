
resource "aws_autoscaling_group" "web_asg" {
  name                      = "jupiter-terraform-asg"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.web_asg_desired_capacity
  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  force_delete = true

  launch_template {
    id      = aws_launch_template.lt_east.id
    version = "$Latest"
  }
  #   vpc_zone_identifier = split(",", data.aws_subnet.for_asg.id)
  vpc_zone_identifier = [
    aws_subnet.privateterraform_subnets["Private_Subnet_AZ1"].id,
    aws_subnet.privateterraform_subnets["Private_Subnet_AZ2"].id,
  ]


  instance_refresh {
    strategy = "Rolling"
    # preferences {
    #   min_healthy_percentage = 50
    # }
    triggers = ["tag"]
  }
  tag {
    key                 = "Name"
    value               = "tf-Webservers-asg"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}