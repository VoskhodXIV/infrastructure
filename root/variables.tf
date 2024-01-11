variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block subnet range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Infrastructure environment: dev/staging/prod"
  type        = string
  default     = "dev"
}

variable "public_subnets" {
  description = "List of public IPV4 subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "List of private IPV4 subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "database" {
  description = "Database name"
  type        = string
  default     = "dev"
}

variable "dbuser" {
  description = "Database username"
  type        = string
  default     = "dev_user"
}

variable "ssh_key_file" {
  description = "ssh-keygen generated public RSA key to SSH into an EC2 instance"
  type        = string
  default     = "ec2_ssh_key.pub"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "device_name" {
  description = "EC2 instance device name"
  type        = string
  default     = "/dev/sda1"
}

variable "volume_size" {
  description = "EC2 instance volume size"
  type        = number
  default     = 50
}

variable "volume_type" {
  description = "EC2 instance volume type"
  type        = string
  default     = "gp2"
}

variable "domain" {
  description = "Domain name with TLD"
  type        = string
  default     = "dev.sydrawat.me"
}
