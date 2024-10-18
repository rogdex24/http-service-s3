# HTTP Service with S3 Integration

This project sets up an HTTP service that interacts with AWS S3. The infrastructure is managed using Terraform, and the HTTP service is built with Node.js.

## Table of Contents

- [Design Decisions](#design-decisions)
- [Assumptions](#assumptions)
- [Setup Instructions](#setup-instructions)
- [Directory Structure](#directory-structure)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Design Decisions

1. **Infrastructure as Code (IaC)**: Terraform is used to manage the AWS infrastructure.
2. **Node.js for HTTP Service**: Node.js is chosen for ease of integration with AWS SDKs.
3. **PM2 for Process Management**: PM2 is used to manage the Node.js process, ensuring that the service is always running and can recover from crashes.
4. **S3 Access**: S3 Access is given through  IAM Instance Profile (IAM Role) for the instance which has the ListObject Permissions, which is secure and easily manageable rather than using Access Keys


## Assumptions

1. **AWS Credentials**: It is assumed that AWS credentials are configured on the machine where Terraform is run.
2. **VPC and Subnets**: The project assumes that a default VPC and subnets are available in the AWS account.
3. **Ubuntu AMI**: The EC2 instance is assumed to be running an Ubuntu AMI.
4. **Internet Access**: The EC2 instance requires internet access to clone the GitHub repository and install dependencies.

## Setup Instructions
The Terraform script has userdata / installation script which would install and run the API Endpoint

1. **Clone the Repository**:

   ```sh
   git clone https://github.com/your-repo/http-service-s3.git
   cd http-service-s3
   ```

2. **Run Terraform**:

   ```sh
   cd terraform
   terraform init
   terraform apply
   ```
