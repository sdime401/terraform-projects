data "aws_ami" "Amazon_linux_2_AMI" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_launch_template" "lt_east" {
  name = "terraform-jupitar-lt"
  iam_instance_profile {
    name = "SSMandS3Fullaccess"
  }

  image_id = data.aws_ami.Amazon_linux_2_AMI.id 

  instance_type = "t2.micro"

  key_name = "jupiter-key"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }


  vpc_security_group_ids = ["${aws_security_group.webserver_sg.id}"]


  user_data = filebase64("${path.module}/user-data.sh") # I had to modify the IAM instance profile to add the policy ec2:DescribeInstanceAttribute
  # that will allow EC2 service to read metadata thus allowing the user data script to run
  depends_on = [aws_security_group.webserver_sg, aws_s3_object.jupitar_object]

  lifecycle {
    create_before_destroy = true
  }
}
