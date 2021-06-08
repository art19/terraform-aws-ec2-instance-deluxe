output "alarm_instance_failed_name" {
  description = "List of instance failed alarm names"
  value       = aws_cloudwatch_metric_alarm.this_instance_failed.*.alarm_name
}

output "alarm_system_failed_name" {
  description = "List of system failed alarm names"
  value       = aws_cloudwatch_metric_alarm.this_system_failed.*.alarm_name
}

output "availability_zone" {
  description = "List of availability zones of instances"
  value       = [for stack in aws_cloudformation_stack.this : stack.outputs["EC2InstanceAvailabilityZone"]]
}

output "id" {
  description = "List of IDs of instances"
  value       = [for stack in aws_cloudformation_stack.this : stack.outputs["EC2InstanceId"]]
}

output "instance_count" {
  description = "Number of instances to launch specified as argument to this module"
  value       = var.instance_count
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = [for stack in aws_cloudformation_stack.this : stack.outputs["EC2InstancePublicDnsName"]]
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = [for stack in aws_cloudformation_stack.this : stack.outputs["EC2InstancePublicIp"]]
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = [for stack in aws_cloudformation_stack.this : stack.outputs["EC2InstancePrivateDnsName"]]
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = [for stack in aws_cloudformation_stack.this : stack.outputs["EC2InstancePrivateIp"]]
}

output "registered_fqdn" {
  description = "List of FQDNs assigned to the instances"
  value       = aws_route53_record.this.*.fqdn
}

