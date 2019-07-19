locals {
  # adds a dot and the DNS suffix if one is provided, otherwise it's blank
  dns_suffix         = "${var.dns_suffix == "" ? "" : ".${var.dns_suffix}"}"
  is_t_instance_type = "${replace(var.instance_type, "/^t[23]{1}\\..*$/", "1") == "1" ? "1" : "0"}"

  # Get the list of partition numbers
  partition_numbers = "${distinct(compact(concat(list(var.placement_partition_number), var.placement_partition_numbers)))}"
}
