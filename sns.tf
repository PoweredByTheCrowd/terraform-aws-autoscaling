resource "aws_sns_topic" "cleanup_instances" {
  name = "${aws_autoscaling_group.group.name}-cleanup-instances"
}