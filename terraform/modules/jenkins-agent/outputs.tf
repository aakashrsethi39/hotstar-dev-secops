output "instance_id" {
  value = aws_instance.agent.id
}

output "private_ip" {
  value = aws_instance.agent.private_ip
}

output "security_group_id" {
  value = aws_security_group.agent.id
}
