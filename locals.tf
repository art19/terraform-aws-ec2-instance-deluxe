locals {
  # adds a dot and the DNS suffix if one is provided, otherwise it's blank
  dns_suffix         = "${var.dns_suffix == "" ? "" : ".${var.dns_suffix}"}"
  is_t_instance_type = "${replace(var.instance_type, "/^t[23]{1}\\..*$/", "1") == "1" ? "1" : "0"}"

  # Create a name like node0001.dns.suffix, node0001, your-node-name, or your-node-name.dns.suffix depending on what you've passed in.
  name = "${(var.instance_count > 1) || (var.use_num_suffix == "true") ? format("node%04d%s", count.index+1, local.dns_suffix) : format("%s%s", var.name, local.dns_suffix)}"

  # Get the list of partition numbers
  partition_numbers = "${distinct(compact(concat(list(var.placement_partition_number), var.placement_partition_numbers)))}"
}
