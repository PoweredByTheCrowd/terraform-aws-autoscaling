resource "aws_launch_configuration" "launch_config" {
//  environment = "${var.environment}_config"
  name_prefix = "${var.name_prefix}"
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  user_data = "${data.template_file.user-data.rendered}"
  security_groups = ["${var.security_groups}"]

  root_block_device {
    volume_size = "${var.volume_size}"
    volume_type = "standard"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "group" {
  name                 = "${var.environment}"
  launch_configuration = "${aws_launch_configuration.launch_config.name}"
  min_size             = "${var.launch_config_min_size}"
  max_size             = "${var.launch_config_max_size}"
  desired_capacity     = "${var.launch_config_desired_size}"

  vpc_zone_identifier   =  ["${var.private_subnet_ids}"]
  termination_policies  = ["OldestInstance"]
  tags = [
    {
      key                 = "Env"
      value               = "${var.environment}-rancher-host"
      propagate_at_launch = true
    },
    {
      key                 = "spot-enabled"
      value               = "true"
      propagate_at_launch = false
    },
  ]
}

resource "aws_autoscaling_attachment" "asg_attachment_https" {
  autoscaling_group_name = "${aws_autoscaling_group.group.id}"
  alb_target_group_arn   = "${var.alb_target_group_https_arn}"
}


resource "aws_autoscaling_attachment" "asg_attachment_http" {
  autoscaling_group_name = "${aws_autoscaling_group.group.id}"
  alb_target_group_arn   = "${var.alb_target_group_http_arn}"
}

resource "aws_autoscaling_lifecycle_hook" "cleanup_instance" {
  name                   = "${var.environment}-cleanup-asg-${aws_autoscaling_group.group.id}"
  autoscaling_group_name = "${aws_autoscaling_group.group.name}"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 180
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  notification_target_arn = "${aws_sns_topic.cleanup_instances.arn}"
  role_arn                = "${aws_iam_role.autoscaling_cleanup_iam_role.arn}"
}

output "asg-name" { value = "${aws_autoscaling_group.group.name}"}