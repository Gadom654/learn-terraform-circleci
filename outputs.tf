output "cluster_nodes" {
  value = [
    for i in concat([aws_instance.apache], aws_instance.flasks, ) : {
      name       = i.tags["terraform-kubeadm:node"]
      subnet_id  = i.subnet_id
      private_ip = i.private_ip
      public_ip  = i.tags["terraform-kubeadm:node"] == "apache" ? aws_eip.apache.public_ip : i.public_ip
    }
  ]
  description = "Name, public and private IP address, and subnet ID of all nodes of the created cluster."
}

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
