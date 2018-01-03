resource "aws_iam_policy" "asg_cleanup_instance" {
  name        = "${aws_autoscaling_group.group.name}_cleanup_instance"
  policy = "${data.aws_iam_policy_document.iam_for_asg_cleanup_instance_policy.json}"
}


data "aws_iam_policy_document" "iam_for_asg_cleanup_instance_policy" {

  statement {
    actions = [
      "sns:*"
    ]

    resources = [
      "${aws_sns_topic.cleanup_instances.arn}",
      "${aws_sns_topic.cleanup_instances.arn}:*"

    ]
  }
}

data "aws_iam_policy_document" "iam_asg_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = [
        "autoscaling.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "lambda_cleanup" {
  name   = "${var.environment}_${aws_sns_topic.cleanup_instances.name}_lambda_cleanup"
  policy = "${data.aws_iam_policy_document.iam_for_lambda_cleanup.json}"
}

data "aws_iam_policy_document" "iam_for_lambda_cleanup" {
  statement {
    actions = [
      "sns:GetTopicAttributes",
      "sns:Subscribe"
    ]

    resources = [
      "${aws_sns_topic.cleanup_instances.arn}"
    ]
  }

  statement {
    actions = [
      "ec2:DescribeInstances",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "kms:DescribeKey",
      "kms:List*",
      "kms:Get*",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
    ]

    resources = [
      "${aws_kms_key.kms_key.arn}"
    ]

  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    actions = [
      "logs:*"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

data "aws_iam_policy_document" "lambda_cleanup_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}
