# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
# TODO: Use custom Packer-built AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.api_sg_id]
  subnet_id                   = var.public_subnets_id[0]
  disable_api_termination     = false
  key_name                    = var.ssh_key_name

  ebs_block_device {
    delete_on_termination = true
    device_name           = var.device_name
    volume_size           = var.volume_size
    volume_type           = var.volume_type
  }

  tags = {
    Name = "${var.environment}-api-server"
  }
}
