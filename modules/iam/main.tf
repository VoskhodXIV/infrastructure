# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "ec2_access_role" {
  name = "ec2-access-role"

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
    "Name" = "${var.environment}-iam-ec2-access-role"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy
data "aws_iam_policy" "cloudwatch_server_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "s3_policy" {
  name        = "s3-policy"
  path        = "/"
  description = "Allow S3 access to API"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.s3_bucket.bucket}",
          "arn:aws:s3:::${var.s3_bucket.bucket}/*"
        ]
      },
    ]
  })

  tags = {
    "Name" = "${var.environment}-iam-s3-policy"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
resource "aws_iam_policy_attachment" "s3_policy_role" {
  name       = "s3-policy-attachment"
  roles      = [aws_iam_role.ec2_access_role.name]
  policy_arn = aws_iam_policy.s3_policy.arn
}
resource "aws_iam_policy_attachment" "cloudwatch_policy_role" {
  name       = "cloudwatch-policy-attachment"
  roles      = [aws_iam_role.ec2_access_role.name]
  policy_arn = data.aws_iam_policy.cloudwatch_server_policy.arn
}

resource "aws_iam_instance_profile" "iam_ec2_s3_profile" {
  name = "ec2-s3-profile"
  role = aws_iam_role.ec2_access_role.name
}
