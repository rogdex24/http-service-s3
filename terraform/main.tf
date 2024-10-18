data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_instance" "my_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
  }

  user_data = <<-EOF
              #!/bin/bash

              cat << 'SCRIPT' > /home/ubuntu/run_setup.sh
              #!/bin/bash
              cd ~
              git clone https://github.com/rogdex24/http-service-s3.git
              cd http-service-s3
              chmod +x setup.sh
              ./setup.sh ${aws_s3_bucket.my_bucket.bucket}
              SCRIPT
              
              chmod +x /home/ubuntu/run_setup.sh
              chown ubuntu:ubuntu /home/ubuntu/run_setup.sh
              su - ubuntu -c "/home/ubuntu/run_setup.sh"
              EOF

  tags = {
    Name = "test-instance"
  }
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 1444
    to_port     = 1444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name = "ec2_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = aws_iam_role.ec2_s3_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "s3:ListBucket",
        "s3:GetObject"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_s3_access_role.name
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "sample_folder1" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "folder1/"  
}

resource "aws_s3_object" "sample_file1" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "sample1.txt"
  source = "./data/sample_file1.txt"  
}

resource "aws_s3_object" "sample_file2" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "folder1/sample2.txt" 
  source = "./data/sample_file2.txt" 
}