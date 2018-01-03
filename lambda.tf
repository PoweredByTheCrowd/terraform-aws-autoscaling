resource "aws_lambda_function" "cleanup_rancher_instance" {
  filename         = "${var.cleanup_rancher_script}"
  function_name    = "${var.environment}-cleanup-rancher-instance"
  role             = "${aws_iam_role.lamdba_cleanup_role.arn}"
  runtime          = "python3.6"
  handler          = "handler.lambda_handler"
  source_code_hash = "${base64sha256(file(var.cleanup_rancher_script))}"
  timeout          = 300
  memory_size      = 128
  kms_key_arn      = "${aws_kms_key.kms_key.arn}"
  vpc_config {
    subnet_ids = ["${var.private_subnet_ids}"]
    security_group_ids= ["${var.security_groups}"]
  }
  environment      = {
    variables {
      RANCHER_ACCESS_KEY = "${var.rancher_access_key}"
      RANCHER_SECRET_KEY = "${var.rancher_secret_key}"
      RANCHER_URL        = "${var.rancher_api_url}"
    }
  }
}


resource "aws_sns_topic_subscription" "topic_lambda" {
  topic_arn = "${aws_sns_topic.cleanup_instances.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.cleanup_rancher_instance.arn}"
}


resource "aws_lambda_permission" "with_sns" {
  statement_id = "AllowExecutionFromSNS"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.cleanup_rancher_instance.arn}"
  principal = "sns.amazonaws.com"
  source_arn = "${aws_sns_topic.cleanup_instances.arn}"
}
