output "bucket_name" {
  value = aws_s3_bucket.uploads.bucket
}

output "instance_id" {
  value = aws_instance.app.id
}

output "app_url" {
  value = "http://${aws_instance.app.public_ip}"
}

output "vpc_id" {
  value = aws_vpc.main.id
}