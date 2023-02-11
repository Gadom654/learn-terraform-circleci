output "vpc_id" {
  value       = aws_security_group.egress.vpc_id
  description = "ID of the VPC in which the cluster has been created."
}
output "vpc_id_network" {
  value       = aws_vpc.main.id
  description = "ID of the created VPC."
}

output "subnet_id" {
  value       = aws_subnet.main.id
  description = "ID of the created subnet."
}
