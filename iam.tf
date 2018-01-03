resource "aws_iam_role" "autoscaling_cleanup_iam_role" {
  name = "${var.environment}_autoscaling_allow_sns"
  assume_role_policy = "${data.aws_iam_policy_document.iam_asg_assume_role_policy.json}"
}

resource "aws_iam_role_policy" "autoscaling_iam_role_policy" {
  name = "${var.environment}_autoscaling_allow_sns"
  role = "${aws_iam_role.autoscaling_cleanup_iam_role.id}"
  policy = "${data.aws_iam_policy_document.iam_for_asg_cleanup_instance_policy.json}"
}

resource "aws_iam_role" "lamdba_cleanup_role" {
  name = "${var.environment}_lambda_assume_role_cleanup"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_cleanup_assume_role.json}"
}

resource "aws_iam_role_policy" "lamdba_cleanup_policy" {
  name = "${var.environment}_lamdba_cleanup"
  role = "${aws_iam_role.lamdba_cleanup_role.id}"
  policy = "${data.aws_iam_policy_document.iam_for_lambda_cleanup.json}"
}


resource "aws_iam_role_policy_attachment" "lamdba_vpc_policy" {
  role       = "${aws_iam_role.lamdba_cleanup_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}