######
# Note: network_interface can't be specified together with associate_public_ip_address
######
resource "aws_instance" "this" {
  count = "${var.instance_count * (1 - local.is_t_instance_type)}"

  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  user_data              = "${element(distinct(compact(concat(list(var.user_data), var.user_datas))),count.index)}"
  subnet_id              = "${length(local.subnet_ids) == 0 ? "" : element(local.subnet_ids, count.index)}"
  key_name               = "${var.key_name}"
  monitoring             = "${var.monitoring}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  iam_instance_profile   = "${var.iam_instance_profile}"

  associate_public_ip_address = "${var.associate_public_ip_address}"
  private_ip                  = "${element(distinct(compact(concat(list(var.private_ip), var.private_ips))),count.index)}"
  ipv6_address_count          = "${var.ipv6_address_count}"
  ipv6_addresses              = "${var.ipv6_addresses}"

  ebs_optimized          = "${var.ebs_optimized}"
  root_block_device      = "${var.root_block_device}"
  ebs_block_device       = "${var.ebs_block_device}"
  ephemeral_block_device = "${var.ephemeral_block_device}"

  source_dest_check                    = "${var.source_dest_check}"
  disable_api_termination              = "${var.disable_api_termination}"
  instance_initiated_shutdown_behavior = "${var.instance_initiated_shutdown_behavior}"
  placement_group                      = "${var.placement_group}"
  placement_partition_number           = "${length(local.partition_numbers) == 0 ? "" : element(local.partition_numbers, count.index)}"
  tenancy                              = "${var.tenancy}"

  tags        = "${merge(map("Name", (var.instance_count > 1) || (var.use_num_suffix == "true") ? format("node%04d%s", count.index+1, local.dns_suffix) : format("%s%s", var.name, local.dns_suffix)), var.tags)}"
  volume_tags = "${merge(map("Name", (var.instance_count > 1) || (var.use_num_suffix == "true") ? format("node%04d%s", count.index+1, local.dns_suffix) : format("%s%s", var.name, local.dns_suffix)), var.volume_tags)}"

  lifecycle {
    # Due to several known issues in Terraform AWS provider related to arguments of aws_instance:
    # (eg, https://github.com/terraform-providers/terraform-provider-aws/issues/2036)
    # we have to ignore changes in the following arguments
    ignore_changes = ["private_ip", "root_block_device", "ebs_block_device"]
  }
}

resource "aws_instance" "this_t2" {
  count = "${var.instance_count * local.is_t_instance_type}"

  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  user_data              = "${element(distinct(compact(concat(list(var.user_data), var.user_datas))),count.index)}"
  subnet_id              = "${length(local.subnet_ids) == 0 ? "" : element(local.subnet_ids, count.index)}"
  key_name               = "${var.key_name}"
  monitoring             = "${var.monitoring}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  iam_instance_profile   = "${var.iam_instance_profile}"

  associate_public_ip_address = "${var.associate_public_ip_address}"
  private_ip                  = "${element(distinct(compact(concat(list(var.private_ip), var.private_ips))),count.index)}"
  ipv6_address_count          = "${var.ipv6_address_count}"
  ipv6_addresses              = "${var.ipv6_addresses}"

  ebs_optimized          = "${var.ebs_optimized}"
  root_block_device      = "${var.root_block_device}"
  ebs_block_device       = "${var.ebs_block_device}"
  ephemeral_block_device = "${var.ephemeral_block_device}"

  source_dest_check                    = "${var.source_dest_check}"
  disable_api_termination              = "${var.disable_api_termination}"
  instance_initiated_shutdown_behavior = "${var.instance_initiated_shutdown_behavior}"
  placement_group                      = "${var.placement_group}"
  placement_partition_number           = "${length(local.partition_numbers) == 0 ? "" : element(local.partition_numbers, count.index)}"
  tenancy                              = "${var.tenancy}"

  credit_specification {
    cpu_credits = "${var.cpu_credits}"
  }

  tags        = "${merge(map("Name", (var.instance_count > 1) || (var.use_num_suffix == "true") ? format("node%04d%s", count.index+1, local.dns_suffix) : format("%s%s", var.name, local.dns_suffix)), var.tags)}"
  volume_tags = "${merge(map("Name", (var.instance_count > 1) || (var.use_num_suffix == "true") ? format("node%04d%s", count.index+1, local.dns_suffix) : format("%s%s", var.name, local.dns_suffix)), var.volume_tags)}"

  lifecycle {
    # Due to several known issues in Terraform AWS provider related to arguments of aws_instance:
    # (eg, https://github.com/terraform-providers/terraform-provider-aws/issues/2036)
    # we have to ignore changes in the following arguments
    ignore_changes = ["private_ip", "root_block_device", "ebs_block_device"]
  }
}
