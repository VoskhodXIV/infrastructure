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
# resource "aws_instance" "ec2" {
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = var.instance_type
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [var.api_sg_id]
#   subnet_id                   = var.public_subnets_id[0]
#   disable_api_termination     = false
#   key_name                    = var.ssh_key_name

#   ebs_block_device {
#     delete_on_termination = true
#     device_name           = var.device_name
#     volume_size           = var.volume_size
#     volume_type           = var.volume_type
#   }

#   tags = {
#     Name = "${var.environment}-api-server"
#   }
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
resource "aws_launch_template" "ec2_launch_template" {
  name                                 = "${var.environment}-launch-template"
  image_id                             = data.aws_ami.ubuntu.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  disable_api_termination              = false
  key_name                             = var.ssh_key_name
  # vpc_security_group_ids               = [var.api_sg_id]

  iam_instance_profile {
    name = var.iam_ec2_s3_profile.name
  }

  block_device_mappings {
    device_name = var.device_name
    ebs {
      delete_on_termination = true
      volume_size           = var.volume_size
      volume_type           = var.volume_type
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [var.api_sg_id]
  }

  user_data = base64encode("${templatefile("../modules/ec2/userdata.sh", {
    ENVIRONMENT = "${var.environment}"
    DATABASE    = "${var.database}",
    DBUSER      = "${var.dbuser}",
    DBPASSWORD  = "${var.dbpassword}",
  })}")

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Name" = "${var.environment}-launch-template"
    }
  }
}
