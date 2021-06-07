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
    var.dns_ip_type == "private" ? aws_instance.this.*.private_ip[count.index] : aws_instance.this.*.public_ip[count.index]
  ]
}
