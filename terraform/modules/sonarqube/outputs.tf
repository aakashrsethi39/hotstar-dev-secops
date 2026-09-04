output "sonarqube_instance_id" {
  value = aws_instance.sonarqube.id
}

output "sonarqube_public_ip" {
  value = aws_instance.sonarqube.public_ip
}

output "sonarqube_security_group_id" {
  value = aws_security_group.sonarqube.id
}