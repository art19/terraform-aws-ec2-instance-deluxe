locals {
  # adds a dot and the DNS suffix if one is provided, otherwise it's blank
  dns_suffix = "${var.dns_suffix == "" ? "" : ".${var.dns_suffix}"}"

  # DRYed up instance counts by instance type
  instance_count   = "${var.instance_count * (1 - local.is_t_instance_type)}"
  instance_count_t = "${var.instance_count * local.is_t_instance_type}"

  # Returns 1 if this is a t instance type, 0 otherwise
  is_t_instance_type = "${replace(var.instance_type, "/^t[23]{1}[a]?\\..*$/", "1") == "1" ? "1" : "0"}"

  # Get the list of partition numbers
  partition_numbers = "${distinct(compact(concat(list(var.placement_partition_number), var.placement_partition_numbers)))}"

  # The list of subnet IDs
  subnet_ids = ["${distinct(compact(concat(list(var.subnet_id), var.subnet_ids)))}"]
}
