resource "aws_route53_record" "this" {
  count = "${(var.dns_zone_id == "" || var.dns_suffix == "") ? 0 : local.instance_count}"

  zone_id = "${var.dns_zone_id}"
  name    = "${(var.instance_count > 1) || (var.use_num_suffix == "true") ? format("%s%04d%s", var.dns_name, count.index+1, local.dns_suffix) : format("%s%s", var.dns_name, local.dns_suffix)}." # trailing dot intentional
  type    = "A"
  ttl     = "${var.dns_ttl}"
  records = ["${var.dns_ip_type == "private" ? aws_instance.this.*.private_ip[count.index] : aws_instance.this.*.public_ip[count.index]}"]
}

resource "aws_route53_record" "this_t2" {
  count = "${(var.dns_zone_id == "" || var.dns_suffix == "") ? 0 : local.instance_count_t}"

  zone_id = "${var.dns_zone_id}"
  name    = "${(var.instance_count > 1) || (var.use_num_suffix == "true") ? format("%s%04d%s", var.dns_name, count.index+1, local.dns_suffix) : format("%s%s", var.dns_name, local.dns_suffix)}." # trailing dot intentional
  type    = "A"
  ttl     = "${var.dns_ttl}"
  records = ["${var.dns_ip_type == "private" ? aws_instance.this_t2.*.private_ip[count.index] : aws_instance.this_t2.*.public_ip[count.index]}"]
}
