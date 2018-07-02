variable "cluster_size" {}

variable "max_price" {
  default = "0.005"
}

variable "valid_until" {
  default = "2022-11-04T20:44:20Z"
}

variable "amazon_ami_name" {
  type        = "string"
  description = "The name of the Amazon Linux ami to pull from"
  default     = "amzn-ami-*-amazon-ecs-optimized"
}

variable "subnet_ids" {
  type    = "list"
  default = []
}

variable "vpc_id" {}

variable "key_name" {}

variable "cluster_name" {
  type        = "string"
  description = "name to assign to cluster nodes"
  default     = "spot_fleet_instance"
}

#Re-enable once consul cluster is available
//variable "consul_instance_sg" {}

//variable "consul_elb_address" {}

variable "region" {}

variable "env" {}

variable "volume_size" {
  default = "40"
}

/*
CloudWatch configurations.
*/

variable "cpu_util_metric_name" {
  default = "CPUUtilization"
}

variable "cpu_util_period" {
  default = 60
}

variable "cpu_util_evaluation_periods" {
  default = 2
}

variable "cpu_util_threshold" {
  default = 80
}

variable "cpu_util_namespace" {
  default = "AWS/ECS"
}

variable "cpu_util_comparison_operator" {
  default = "GreaterThanOrEqualToThreshold"
}

variable "cpu_util_statistic" {
  default = "Average"
}

variable "memory_util_metric_name" {
  default = "MemoryUtilization"
}

variable "memory_util_period" {
  default = 60
}

variable "memory_util_evaluation_periods" {
  default = 2
}

variable "memory_util_threshold" {
  default = 80
}

variable "memory_util_namespace" {
  default = "AWS/ECS"
}

variable "memory_util_comparison_operator" {
  default = "GreaterThanOrEqualToThreshold"
}

variable "memory_util_statistic" {
  default = "Average"
}

variable "notification" {
  default = ["arn:aws:sns:us-west-2:1234567890:no-alarm"]
}
