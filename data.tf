# Allows us to get the current account ID
data "aws_caller_identity" "current" {}

# Allows us to get the AWS partition in use (nearly always `aws`)
data "aws_partition" "current" {}

# Allows us to get the AWS region in use
data "aws_region" "current" {}
