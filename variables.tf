variable "autoreboot_enabled" {
  description = "Whether or not EC2 autoreboot is enabled for this/every instance when the OS fails status checks."
  default     = "true"
}

variable "autorecovery_enabled" {
  description = "Whether or not EC2 autorecovery is enabled for this/every instance when the AWS hardware fails status checks."
  default     = "true"
}

variable "dns_ip_type" {
  description = "Which type of IP to include in the DNS record, either public or private"
  default     = "private"
}

variable "dns_name" {
  description = "The DNS name to use for the node/nodes. Defaults to 'node' to make names like 'node0001' and 'node'."
  default     = "node"
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
  type        = string
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  type        = string
  default     = ""
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  type        = string
  default     = "default"
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance" # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = ""
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "placement_partition_number" {
  description = "If using a partition placement group, the placement partition number"
  default     = null
}

variable "placement_partition_numbers" {
  description = "If using a partition placement group, the placement partition numbers (if more than one instance)"
  type        = list(string)
  default     = []
}

variable "skip_launch" {
  type        = bool
  description = "Whether to skip launching instance(s), in the case you need to migrate already running ones"
  default     = false
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of VPC Subnet IDs to launch in"
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  description = "If true, the EC2 instance will have associated public IP address"
  type        = bool
  default     = null
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "private_ips" {
  description = "A list of private IP address to associate with the instance in a VPC. Should match the number of instances."
  type        = list(string)
  default     = []
}

variable "user_data_base64" {
  description = "Use to pass base64-encoded user data."
  type        = string
  default     = null
}

variable "user_datas_base64" {
  description = "Use to pass base64-encoded user data for each distinct instance being launched."
  type        = list(string)
  default     = []
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
  type        = string
  default     = ""
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet."
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(map(string))
  default     = []
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type        = list(map(string))
  default     = []
}

variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  type        = string
  default     = "standard"
}

variable "use_num_suffix" {
  description = "Always append numerical suffix to instance name, even if instance_count is 1"
  type        = bool
  default     = false
}

variable "num_suffix_format" {
  description = "Numerical suffix format used as the volume and EC2 instance name suffix"
  type        = string
  default     = "%04d"
}


