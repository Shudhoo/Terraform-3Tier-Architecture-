variable "region" {
  default = "<region>"
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
  default = "<vpc-CIDR>"
  type = string
}

variable "my_public-subnet" {
  default = "<subnet-CIDR>"
  type = string
}

variable "my_private_subnet" {
  default = "<subnet-CIDR>"
  type = string
}

variable "my_private-db-subnet" {
  default = "<subnet-CIDR>"
  type = string
}

# EC2 variables
variable "env" {
  default = "<ENV>"
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
    default = "<instnace-type>"
    type = string
}

variable "Public-ami" {
    default = "<ami-id>"
    type = string
}

# RDS Variabls
variable "rds-username" {
  default = "username"
  type = string
}
 
variable "rds-passwd" {
  default = "pass"
  type = string
}
