data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "app" {
  name   = "${var.project_name}-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "${var.project_name}-sg"
  }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ssm_parameter.ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.app.name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    bucket_name = aws_s3_bucket.uploads.bucket
    aws_region  = var.aws_region
  })

  root_block_device {
    volume_size = 12
    volume_type = "gp3"
    encrypted   = true
  }

  depends_on = [
    aws_iam_role_policy.upload
  ]

  tags = {
    Name = "${var.project_name}-ec2"
  }
}