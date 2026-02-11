provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_role" "this" {
  name = "crossplane"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::${var.management_account_id}:role/crossplane",
      },
      Action = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachments_exclusive" "this" {
  role_name    = aws_iam_role.this.name
  policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}
