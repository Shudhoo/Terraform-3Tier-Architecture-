# 3-Tier Architecture Setup on AWS with Terraform

This project sets up a 3-tier architecture on AWS Cloud using Terraform, demonstrating how to manage infrastructure as code (IaC). The architecture consists of:

- **2 Public EC2 Instances** in a public subnet (Client-side or Frontend)
- **1 Private EC2 Instance** in a private subnet (Business Logic or Backend)
- **1 RDS Instance** in a private subnet (Database)

## Terraform Commands

1. **`terraform validate`**  
   Validates the Terraform configuration to ensure there are no errors in the script.

2. **`terraform plan`**  
   Previews the changes that Terraform will make to the infrastructure.

3. **`terraform apply`**  
   Applies the changes to create or modify the infrastructure as defined in the Terraform configuration.

4. **`terraform state list`**  
   Lists all the resources managed by Terraform in your state file.

## Key Learnings and Insights

### 1. **Variable Management**
   - Variables are stored in separate files for security and ease of modification. This allows for easy updates without hardcoding sensitive information directly into the configuration files.

### 2. **Output Management**
   - Outputs are essential for maintaining visibility of resources created by Terraform, especially for team members who did not create the infrastructure. It allows easy retrieval of important information like public IP addresses, instance IDs, etc.

### 3. **Provider Configuration**
   - The Terraform provider for AWS is configured, and the Terraform version is specified. The AWS account configuration was done manually, but everything else was automated through Terraform.

### 4. **State File Management**
   - The state file is the heart of Terraform as it maintains all information about the infrastructure. I’ve stored the state file remotely in an **S3 bucket** and used **DynamoDB** for state file locking to prevent concurrent modifications. This setup also allows versioning, ensuring the state file remains secure and accessible to the entire team.

## Conclusion

Setting up a 3-tier architecture using Terraform was an insightful experience. While configuring and managing infrastructure can be challenging, Terraform offers a modular and efficient approach to handling complex infrastructures. Terraform’s comprehensive documentation for multiple cloud providers, including AWS, GCP, and Azure, makes it a go-to tool for cloud infrastructure management.

---

## Setup Instructions

You can add resources if you want and replace the variables in the **`variables.tf`** file

### Prerequisites

- **Terraform** (version 5.95.0 or higher) installed on your local machine.
- AWS IAM user with the necessary permissions to provision EC2, RDS, and other resources.

### Steps to Deploy the Infrastructure

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/3-tier-architecture-terraform.git
   cd 3-tier-architecture-terraform
