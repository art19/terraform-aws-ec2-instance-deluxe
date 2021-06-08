# We create an ASG for each instance to work around the fact that we want to support partition
# placement group partition numbers and Terraform does not support (currently) either specifying
# placement partition numbers or launch templates on EC2 instances.
#
# https://github.com/hashicorp/terraform-provider-aws/issues/4264
# https://github.com/hashicorp/terraform-provider-aws/issues/7754
# https://github.com/hashicorp/terraform-provider-aws/pull/10807
# https://github.com/hashicorp/terraform-provider-aws/pull/15360
# https://github.com/hashicorp/terraform-provider-aws/pull/7649
# https://github.com/hashicorp/terraform-provider-aws/pull/7777
resource "aws_autoscaling_group" "this" {
  count = var.instance_count

  name = aws_launch_template.this[count.index].name

  default_cooldown          = 120
  health_check_grace_period = 300
  health_check_type         = "EC2"
  placement_group           = var.placement_group

  # We want one instance in this ASG
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  # We never want to terminate our instances
  suspended_processes = var.skip_launch ? ["Launch", "ReplaceUnhealthy", "Terminate"] : ["ReplaceUnhealthy", "Terminate"]

  # This exists in one subnet
  vpc_zone_identifier = [element(
    distinct(compact(concat([var.subnet_id], var.subnet_ids))),
    count.index
  )]

  launch_template {
    id      = aws_launch_template.this[count.index].id
    version = aws_launch_template.this[count.index].latest_version
  }

  dynamic "tag" {
    for_each = merge(
      {
        "Name" = "${var.instance_count > 1 || var.use_num_suffix ? format("%s${var.num_suffix_format}", var.dns_name, count.index + 1) : var.dns_name}${local.dns_suffix}"
      },
      var.tags
    )

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
