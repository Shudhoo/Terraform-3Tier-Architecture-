variable "region" {
  default = "eu-west-1"
  type = string
}

#Should be according to the region selected above
variable "AZs" {
  default = "eu-west-1a"
  type = string
}

variable "AZs-2" {
  default = "eu-west-1b"
}

variable "my-vpc" {
  default = "10.0.0.0/16"
  type = string
}

variable "my_public-subnet" {
  default = "10.0.1.0/24"
  type = string
}

variable "my_private_subnet" {
  default = "10.0.2.0/24"
  type = string
}

variable "my_private-db-subnet" {
  default = "10.0.3.0/24"
  type = string
}

# EC2 variables
variable "env" {
  default = "Dev"
  type = string
}

variable "Public-EC2-InstanceCount" {
    default = 2
    type = number
}

variable "Private-EC2-InstanceCount" {
    default = 1
    type = number
}

variable "EC2-Instnace-Type" {
    default = "t2.micro"
    type = string
}

variable "Public-ami" {
    default = "ami-0df368112825f8d8f"
    type = string
}

# RDS Variabls
variable "rds-username" {
  default = "admin"
  type = string
}
 
variable "rds-passwd" {
  default = "admin123"
  type = string
}
