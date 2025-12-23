variable "vpc_id" {
  description = "VPC ID for bastion host"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for bastion host"
  type        = list(string)
}

variable "instance_profile" {
  description = "IAM instance profile for bastion EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "AMI ID for bastion host"
  type        = string
}
