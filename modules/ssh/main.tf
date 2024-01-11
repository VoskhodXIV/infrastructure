# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "ssh_key" {
  key_name   = "tf-ssh-key"
  public_key = file("~/.ssh/${var.ssh_key_file}")
}
