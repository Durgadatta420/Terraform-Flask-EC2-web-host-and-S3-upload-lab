resource "aws_iam_role" "app" {
  name = "${var.project_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "upload" {
  name = "${var.project_name}-upload-policy"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject"]
      Resource = "${aws_s3_bucket.uploads.arn}/uploads/*"
    }]
  })
}

resource "aws_iam_instance_profile" "app" {
  name = "${var.project_name}-profile"
  role = aws_iam_role.app.name
}