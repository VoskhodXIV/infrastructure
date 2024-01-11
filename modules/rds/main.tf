# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "dbpassword" {
  length  = 16
  special = false
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [var.private_subnets_id[0], var.private_subnets_id[1]]

  tags = {
    "Name" = "${var.environment}-db-subnet-group"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.Parameters
resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "rds-psql-pg"
  family = "postgres14"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "database" {
  allocated_storage = 10
  db_name           = var.database
  # https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html#API_CreateDBInstance_RequestParameters
  engine                 = "postgres"
  engine_version         = "14"
  instance_class         = "db.t3.micro"
  username               = var.dbuser
  password               = random_password.dbpassword.result
  parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  skip_final_snapshot    = true
  multi_az               = false
  vpc_security_group_ids = [var.db_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  # TODO: Encrypt storage with KMS
  storage_encrypted = false

}
