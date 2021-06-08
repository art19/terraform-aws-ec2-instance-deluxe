locals {
  # adds a dot and the DNS suffix if one is provided, otherwise it's blank
  dns_suffix = var.dns_suffix == "" ? "" : ".${var.dns_suffix}"
}

resource "aws_route53_record" "this" {
  count = var.dns_zone_id == "" ? 0 : var.instance_count

  zone_id = var.dns_zone_id
  name    = "${var.instance_count > 1 || var.use_num_suffix ? format("%s${var.num_suffix_format}", var.dns_name, count.index + 1) : var.dns_name}${local.dns_suffix}." # trailing dot intentional
  type    = "A"
  ttl     = var.dns_ttl
  records = [
    var.dns_ip_type == "private" ? element(coalescelist(aws_cloudformation_stack.this.*.outputs, [{ EC2InstancePrivateIp = "" }]), count.index)["EC2InstancePrivateIp"] : element(coalescelist(aws_cloudformation_stack.this.*.outputs, [{ EC2InstancePublicIp = "" }]), count.index)["EC2InstancePublicIp"]
  ]
}
