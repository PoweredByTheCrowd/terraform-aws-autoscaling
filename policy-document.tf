# The KMS policy document used by the RDS cluster
data "aws_iam_policy_document" "kms_policy" {
  statement {
    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
}