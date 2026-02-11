resource "aws_iam_openid_connect_provider" "this" {
  url            = var.workload_identity_federation.issuer
  client_id_list = [var.workload_identity_federation.audience]
}

data "aws_iam_policy_document" "workload_identity_federation" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this[0].arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${trimprefix(var.workload_identity_federation.issuer, "https://")}:aud"

      values = [var.workload_identity_federation.audience]
    }

    condition {
      test     = "StringLike"
      variable = "${trimprefix(var.workload_identity_federation.issuer, "https://")}:sub"

      values = var.workload_identity_federation.subjects
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "MeshStackCrossplaneBuildingBlockFederatedPolicy"
  assume_role_policy = data.aws_iam_policy_document.workload_identity_federation[0].json
}

resource "aws_iam_role_policy_attachments_exclusive" "this" {
  policy_arns = ["arn:aws:iam::aws:policy/IAMFullAccess"]
  role_name   = aws_iam_role.this.name
}

# Workload Identity Federation
