resource "aws_iam_role" "ec2iam_role" {
  name = "EC2_accessRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ec2iamrole"
  }
}

# Managed IAM policy attachment

resource "aws_iam_role_policy_attachment" "S3role-attach" {
  role       = aws_iam_role.ec2iam_role.name
  policy_arn = var.s3policyarn
}

resource "aws_iam_role_policy_attachment" "SSMrole-attach" {
  role       = aws_iam_role.ec2iam_role.name
  policy_arn = var.ssmpolicyarn
}