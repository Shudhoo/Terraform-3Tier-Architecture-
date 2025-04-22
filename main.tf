# Terraform script to set up VPC, Networking, EC2 instances (2 Public + 1 Private), and RDS (Private)

# Creating a VPC
resource "aws_vpc" "myVPC" {
  cidr_block = var.my-vpc
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = "myVPC"
    Env = "Dev"
  }
}

# Creating a InternetGateway for VPC
resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id
  
  tags = {
    Name = "myIGW"
  }
}

#Creating 2 Subnets (private & public)

#Public Subnet
resource "aws_subnet" "myPublic-Subnet" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.my_public-subnet
    map_public_ip_on_launch = true
    availability_zone = var.AZs

    tags = {
      Name = "myPublic-Subnet"
    }
}

#Private Subnet
resource "aws_subnet" "myPrivate-Subnet" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.my_private_subnet
    map_public_ip_on_launch = false
    availability_zone = var.AZs

    tags = {
      Name = "myPrivate-Subnet"
    }
}

#Private Subnet for RDS
resource "aws_subnet" "myPrivate-DB-Subnet" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.my_private-db-subnet
    map_public_ip_on_launch = false
    availability_zone = var.AZs-2

    tags = {
      Name = "myPrivate-DB-Subnet"
    }
}


# Public Route table
resource "aws_route_table" "myPublic-RT" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }
  tags = {
    Name = "myPublic-RT"
  }
}

# Route table Association of "myPublic-RT"
resource "aws_route_table_association" "PublicRT-Association" {
  subnet_id = aws_subnet.myPublic-Subnet.id
  route_table_id = aws_route_table.myPublic-RT.id
}


# Elastic-IP for nat-gateway
resource "aws_eip" "nat-gatewayIP" {
    domain = "vpc"
}

# Creating NAT-Gateway inside Public-Subnet
resource "aws_nat_gateway" "NAT-Gateway" {
    allocation_id = aws_eip.nat-gatewayIP.id
    subnet_id = aws_subnet.myPublic-Subnet.id

    tags = {
      Name = "NAT-Gateway"
    }

    depends_on = [ aws_internet_gateway.myIGW ]
}

# Private Route Table
resource "aws_route_table" "myPrivate-RT" {
    vpc_id = aws_vpc.myVPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.NAT-Gateway.id
    }
    tags = {
      Name ="myPrivate-RT"
    }
}

# Route table Association of "myPrivate-RT"
resource "aws_route_table_association" "PrivateRT-Association" {
    subnet_id = aws_subnet.myPrivate-Subnet.id
    route_table_id = aws_route_table.myPrivate-RT.id
}

#Security Groups for Public EC2
resource "aws_security_group" "Public-EC2-SG" {
    vpc_id = aws_vpc.myVPC.id
    description = "This security group allow SSH from anywhere (Not-Recommended)"
    tags = {
      Name = "Public-EC2-SG"
    }
    ingress {
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
        description = "SSH to ALL"
    }
    ingress {
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
        description = "HTTP to all"
    }
    ingress {
        from_port = 7777
        to_port = 7777
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
        description = "My Application Port"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

# Secuirty Group for Private EC2
resource "aws_security_group" "Private-EC2-SG" {
    vpc_id = aws_vpc.myVPC.id
    description = "This Security Group allows SSH only from Public EC2 Instnace"
    tags = {
      Name ="Private-EC2-SG"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.Public-EC2-SG.id]
        description = "From Public EC2 only"
    }
      egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "Private-DB-SG" {
  vpc_id = aws_vpc.myVPC.id
  description = "This Security group allows access only to Private EC2"
  tags = {
    Name= "Private-DB-SG"
  }

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.Private-EC2-SG.id]
  }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Key-Pair for EC2 Instnaces
resource "aws_key_pair" "proj-demo" {
    key_name = "proj-demo"
    public_key = file("proj-demo.pub")
}

# My Public-EC2 
resource "aws_instance" "myPublicEC2" {
  
  ami = var.Public-ami
  instance_type = var.EC2-Instnace-Type
  key_name = aws_key_pair.proj-demo.key_name
  subnet_id = aws_subnet.myPublic-Subnet.id
  vpc_security_group_ids = [aws_security_group.Public-EC2-SG.id]
  count  = var.env == "Prod" ? 4 : var.Public-EC2-InstanceCount

  tags = {
    Name ="public-instnaces"
    Env = var.env
  }
}

# My Private-EC2
resource "aws_instance" "myPrivateEC2" {
    ami = var.Public-ami
    instance_type = var.EC2-Instnace-Type
    key_name = aws_key_pair.proj-demo.key_name
    subnet_id = aws_subnet.myPrivate-Subnet.id
    vpc_security_group_ids = [aws_security_group.Private-EC2-SG.id]
    count = var.env == "Prod" ? 2 : var.Private-EC2-InstanceCount

    tags = {
      Name ="private-instnaces"
      Env = var.env
    }
}

# RDS DB-Subnet-Group
resource "aws_db_subnet_group" "rds-SG" {
  name = "rds-subnet-group"
  subnet_ids = [aws_subnet.myPrivate-Subnet.id, aws_subnet.myPrivate-DB-Subnet.id]

  tags  = {
    Name ="rds-subnet-group"
  }
}

resource "aws_db_instance" "RDS-DB" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.rds-username
  password             = var.rds-passwd
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.rds-SG.name
  vpc_security_group_ids = [aws_security_group.Private-DB-SG.id]
  tags = {
    Name = "myrds"
    Env = var.env
  }
}