variable "autoreboot_enabled" {
  description = "Whether or not EC2 autoreboot is enabled for this/every instance when the OS fails status checks."
  default     = "true"
}

variable "autorecovery_enabled" {
  description = "Whether or not EC2 autorecovery is enabled for this/every instance when the AWS hardware fails status checks."
  default     = "true"
}

variable "dns_suffix" {
  description = "An optional DNS suffix for this/every instance - must work in the zone and be present if using DNS registration"
  default     = ""
}

variable "dns_ttl" {
  description = "The TTL of the DNS record created"
  default     = 60
}

variable "dns_zone_id" {
  description = "An optional Route 53 zone ID to register the instance(s) in. If blank, this feature is disabled."
  default     = ""
}

variable "name" {
  description = "Name to be used on all resources as prefix"
}

variable "instance_count" {
  description = "Number of instances to launch"
  default     = 1
}

variable "ami" {
  description = "ID of AMI to use for the instance"
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  default     = ""
}

variable "placement_partition_number" {
  description = "If using a partition placement group, the placement partition number"
  default     = ""
}

variable "placement_partition_numbers" {
  description = "If using a partition placement group, the placement partition numbers (if more than one instance)"
  type        = "list"
  default     = []
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  default     = "default"
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance" # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to start"
}

variable "key_name" {
  description = "The key name to use for the instance"
  default     = ""
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  default     = false
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = "list"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  default     = ""
}

variable "subnet_ids" {
  description = "A list of VPC Subnet IDs to launch in"
  default     = []
  type        = "list"
}

variable "associate_public_ip_address" {
  description = "If true, the EC2 instance will have associated public IP address"
  default     = false
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  default     = ""
}

variable "private_ips" {
  description = "Private IP addresses to associate with a group of instances in a VPC"
  default     = []
  type        = "list"
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  default     = true
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  default     = ""
}

variable "user_datas" {
  description = "The user data to provide when launching the instance, with support for multiple instances"
  type        = "list"
  default     = []
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
  default     = ""
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet."
  default     = 0
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  default     = {}
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  default     = []
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  default     = []
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  default     = []
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  default     = []
}

variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  default     = "standard"
}

variable "use_num_suffix" {
  description = "Always append numerical suffix to instance name, even if instance_count is 1"
  default     = "false"
}
