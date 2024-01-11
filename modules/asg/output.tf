output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "scale_out_policy" {
  value = aws_autoscaling_policy.scale_out_policy
}

output "scale_in_policy" {
  value = aws_autoscaling_policy.scale_in_policy
}
