variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t4g.nano"
}

variable "ami_id" {
  description = "ID of the AMI to use for the EC2 instance"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-bucket-test-4141"
}