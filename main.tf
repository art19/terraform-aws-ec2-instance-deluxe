locals {
  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false

  partition_numbers = compact(concat([var.placement_partition_number], var.placement_partition_numbers))
}

# We create a launch template and CloudFormation stack for each instance to work around the fact that we
# want to support partition placement group partition numbers and Terraform does not support (currently)
# either specifying placement partition numbers or launch templates on EC2 instances.
#
# https://github.com/hashicorp/terraform-provider-aws/issues/4264
# https://github.com/hashicorp/terraform-provider-aws/issues/7754
# https://github.com/hashicorp/terraform-provider-aws/pull/10807
# https://github.com/hashicorp/terraform-provider-aws/pull/15360
# https://github.com/hashicorp/terraform-provider-aws/pull/7649
# https://github.com/hashicorp/terraform-provider-aws/pull/7777
resource "aws_launch_template" "this" {
  count = var.instance_count

  name = var.instance_count > 1 || var.use_num_suffix ? format("%s-%s${var.num_suffix_format}", var.name, var.dns_name, count.index + 1) : var.name

  disable_api_termination              = var.disable_api_termination
  ebs_optimized                        = var.ebs_optimized
  image_id                             = var.ami
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type
  key_name                             = var.key_name

  user_data = element(
    concat(
      compact(concat([var.user_data_base64], var.user_datas_base64)),
      [null]
    ),
    count.index
  )

  dynamic "block_device_mappings" {
    for_each = var.root_block_device

    content {
      device_name = lookup(block_device_mappings.value, "device_name", "/dev/xvda")

      ebs {
        delete_on_termination = lookup(block_device_mappings.value, "delete_on_termination", null)
        encrypted             = lookup(block_device_mappings.value, "encrypted", null)
        iops                  = lookup(block_device_mappings.value, "iops", null)
        kms_key_id            = lookup(block_device_mappings.value, "kms_key_id", null)
        volume_size           = lookup(block_device_mappings.value, "volume_size", null)
        volume_type           = lookup(block_device_mappings.value, "volume_type", null)
      }
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.ebs_block_device

    content {
      device_name = lookup(block_device_mappings.value, "device_name", null)

      ebs {
        delete_on_termination = lookup(block_device_mappings.value, "delete_on_termination", null)
        encrypted             = lookup(block_device_mappings.value, "encrypted", null)
        iops                  = lookup(block_device_mappings.value, "iops", null)
        kms_key_id            = lookup(block_device_mappings.value, "kms_key_id", null)
        snapshot_id           = lookup(block_device_mappings.value, "snapshot_id", null)
        volume_size           = lookup(block_device_mappings.value, "volume_size", null)
        volume_type           = lookup(block_device_mappings.value, "volume_type", null)
      }
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.ephemeral_block_device

    content {
      device_name = lookup(block_device_mappings.value, "device_name", null)

      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)
    }
  }

  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  monitoring {
    enabled = var.monitoring
  }

  network_interfaces {
    device_index = 0

    description = "${var.instance_count > 1 || var.use_num_suffix ? format("%s${var.num_suffix_format}", var.dns_name, count.index + 1) : var.dns_name}${local.dns_suffix} eth0"

    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = true
    ipv6_address_count          = var.ipv6_address_count
    ipv6_addresses              = var.ipv6_addresses
    private_ip_address          = length(var.private_ips) > 0 ? element(var.private_ips, count.index) : var.private_ip
    security_groups             = var.vpc_security_group_ids

    subnet_id = element(
      distinct(compact(concat([var.subnet_id], var.subnet_ids))),
      count.index
    )
  }

  placement {
    group_name       = var.placement_group
    partition_number = length(local.partition_numbers) == 0 ? null : element(local.partition_numbers, count.index)
    tenancy          = var.tenancy
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
        "Name" = "${var.instance_count > 1 || var.use_num_suffix ? format("%s${var.num_suffix_format}", var.dns_name, count.index + 1) : var.dns_name}${local.dns_suffix}"
      },
      var.tags
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      {
        "Name" = "${var.instance_count > 1 || var.use_num_suffix ? format("%s${var.num_suffix_format}", var.dns_name, count.index + 1) : var.dns_name}${local.dns_suffix}"
      },
      var.volume_tags,
    )
  }

  tags = {
    "Name" = var.instance_count > 1 || var.use_num_suffix ? format("%s-%s${var.num_suffix_format}", var.name, var.dns_name, count.index + 1) : var.name
  }
}

resource "aws_cloudformation_stack" "this" {
  count = var.instance_count

  # The name has the launch template version in it to force Terraform to destroy the old stack before creating a new one.
  # This is because CloudFormation has no way to terminate an instance before creating a new one, and if you're specifying something
  # like a private IP, you can't replace instances using the same private IP.
  name          = "${aws_launch_template.this[count.index].name}-v${aws_launch_template.this[count.index].latest_version}"
  template_body = file("${path.module}/instance.cform")

  parameters = {
    HasPublicIp           = var.associate_public_ip_address ? 1 : 0
    LaunchTemplateId      = aws_launch_template.this[count.index].id
    LaunchTemplateVersion = aws_launch_template.this[count.index].latest_version
  }

  tags = merge(
    {
      "Name" = "${var.instance_count > 1 || var.use_num_suffix ? format("%s${var.num_suffix_format}", var.dns_name, count.index + 1) : var.dns_name}${local.dns_suffix}"
    },
    var.tags
  )
}
