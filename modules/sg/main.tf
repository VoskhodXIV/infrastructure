# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Enable SSH,HTTP & HTTPS access on ports 22,80 & 443"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-alb-sg"
  }
}

resource "aws_security_group" "api_sg" {
  name        = "api-sg"
  description = "Enable API access on port 1337"
  vpc_id      = var.vpc_id

  ingress {
    description     = "API Port"
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-api-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow inbound traffic to 5432"
  vpc_id      = var.vpc_id

  ingress {
    description     = "open port 5432 to vpc"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.api_sg.id]
  }

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = -1
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = {
    Name = "${var.environment}-db-sg"
  }
}
