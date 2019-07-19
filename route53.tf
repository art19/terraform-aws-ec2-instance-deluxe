resource "aws_route53_record" "this" {
  count = "${(var.dns_zone_id == "") || (var.dns_suffix == "") ? 0 : var.instance_count * (1 - local.is_t_instance_type)}"

  zone_id = "${var.dns_zone_id}"
  name    = "${(var.instance_count > 1) || (var.use_num_suffix == "true") ? format("node%04d%s", count.index+1, local.dns_suffix) : format("%s%s", var.name, local.dns_suffix)}." # trailing dot intentional
  type    = "A"
  ttl     = "${var.dns_ttl}"
  records = ["${aws_instance.this.*.private_ip[count.index]}"]
}

resource "aws_route53_record" "this_t2" {
  count = "${(var.dns_zone_id == "") || (var.dns_suffix == "") ? 0 : var.instance_count * local.is_t_instance_type}"

  zone_id = "${var.dns_zone_id}"
  name    = "${(var.instance_count > 1) || (var.use_num_suffix == "true") ? format("node%04d%s", count.index+1, local.dns_suffix) : format("%s%s", var.name, local.dns_suffix)}." # trailing dot intentional
  type    = "A"
  ttl     = "${var.dns_ttl}"
  records = ["${aws_instance.this_t2.*.private_ip[count.index]}"]
}
