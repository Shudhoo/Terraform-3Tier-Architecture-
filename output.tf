# This is "output.tf" to display necessary outputs 

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.myVPC.id
}

output "public_subnet_id" {
  description = "The ID of the Public Subnet"
  value = aws_subnet.myPublic-Subnet.id
}

output "private_subnet_id" {
  description = "The ID of the Private Subnet"
  value = aws_subnet.myPrivate-Subnet.id
}

output "private_db_subnet_id" {
  description = "The ID of the Private DB Subnet"
  value = aws_subnet.myPrivate-DB-Subnet.id
}

output "public_ec2_public_ips" {
  description = "Public IPs of the Public EC2 Instances"
  value = aws_instance.myPublicEC2[*].public_ip
}

output "private_ec2_private_ips" {
  description = "Private IPs of the Private EC2 Instances"
  value = aws_instance.myPrivateEC2[*].private_ip
}

output "nat_gateway_ip" {
  description = "Elastic IP associated with NAT Gateway"
  value = aws_eip.nat-gatewayIP.public_ip
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value = aws_db_instance.RDS-DB.endpoint
}

output "rds_db_name" {
  description = "Database name of the RDS instance"
  value = aws_db_instance.RDS-DB.db_name
}
