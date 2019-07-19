# Reference: <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UsingAlarmActions.html#AddingRebootActions>
resource "aws_cloudwatch_metric_alarm" "this_instance_failed" {
  count = "${var.autorecovery_enabled == "true" ? var.instance_count * (1 - local.is_t_instance_type) : 0}"

  alarm_name          = "${(var.instance_count > 1) || (var.use_num_suffix == "true") ? format("%s-node%04d", var.name, count.index+1) : var.name}-instance-status-check"
  alarm_description   = "Trigger an instance reboot if an instance status check fails for 3 consecutive minutes. Managed by Terraform, do not edit in the console!"
  alarm_actions       = ["arn:${data.aws_partition.current.partition}:swf:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:action/actions/AWS_EC2.InstanceId.Reboot/1.0"]
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 3
  evaluation_periods  = 3
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0

  dimensions {
    InstanceId = "${aws_instance.this.*.id[count.index]}"
  }
}

# Reference: <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UsingAlarmActions.html#AddingRecoverActions>
resource "aws_cloudwatch_metric_alarm" "this_system_failed" {
  count = "${var.autorecovery_enabled == "true" ? var.instance_count * (1 - local.is_t_instance_type) : 0}"

  alarm_name          = "${(var.instance_count > 1) || (var.use_num_suffix == "true") ? format("%s-node%04d", var.name, count.index+1) : var.name}-system-status-check"
  alarm_description   = "Trigger an instance recovery if a system status check fails for 2 consecutive minutes. Managed by Terraform, do not edit in the console!"
  alarm_actions       = ["arn:${data.aws_partition.current.partition}:automate:${data.aws_region.current.name}:ec2:recover"]
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 2
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0

  dimensions {
    InstanceId = "${aws_instance.this.*.id[count.index]}"
  }
}

# Reference: <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UsingAlarmActions.html#AddingRebootActions>
resource "aws_cloudwatch_metric_alarm" "this_t2_instance_failed" {
  count = "${var.autorecovery_enabled == "true" ? var.instance_count * local.is_t_instance_type : 0}"

  alarm_name          = "${(var.instance_count > 1) || (var.use_num_suffix == "true") ? format("%s-node%04d", var.name, count.index+1) : var.name}-instance-status-check"
  alarm_description   = "Trigger an instance reboot if an instance status check fails for 3 consecutive minutes. Managed by Terraform, do not edit in the console!"
  alarm_actions       = ["arn:${data.aws_partition.current.partition}:swf:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:action/actions/AWS_EC2.InstanceId.Reboot/1.0"]
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 3
  evaluation_periods  = 3
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0

  dimensions {
    InstanceId = "${aws_instance.this_t2.*.id[count.index]}"
  }
}

# Reference: <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UsingAlarmActions.html#AddingRecoverActions>
resource "aws_cloudwatch_metric_alarm" "this_t2_system_failed" {
  count = "${var.autorecovery_enabled == "true" ? var.instance_count * local.is_t_instance_type : 0}"

  alarm_name          = "${(var.instance_count > 1) || (var.use_num_suffix == "true") ? format("%s-node%04d", var.name, count.index+1) : var.name}-system-status-check"
  alarm_description   = "Trigger an instance recovery if a system status check fails for 2 consecutive minutes. Managed by Terraform, do not edit in the console!"
  alarm_actions       = ["arn:${data.aws_partition.current.partition}:automate:${data.aws_region.current.name}:ec2:recover"]
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 2
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0

  dimensions {
    InstanceId = "${aws_instance.this_t2.*.id[count.index]}"
  }
}
