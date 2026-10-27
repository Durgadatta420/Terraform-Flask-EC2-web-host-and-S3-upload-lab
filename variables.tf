variable "aws_region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "flask-upload-lab"
}

variable "vpc_cidr" {
  default = "192.168.0.0/24"
}

variable "subnet_cidr" {
  default = "192.168.0.0/26"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "upload_expiration_days" {
  description = "Days before uploaded objects expire"
  type        = number
  default     = 30
}