output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "api_sg_id" {
  value = aws_security_group.api_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}
