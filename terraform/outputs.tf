output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.my_ec2_instance.id
}

output "bucket_name" {
  description = "Name of  the S3 bucket"
  value       = aws_s3_bucket.my_bucket.bucket
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_ec2_instance.public_ip
}