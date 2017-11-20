variable "cluster_size" {}

variable "max_price" {
  default = "0.005"
}

variable "valid_until" {
  default = "2022-11-04T20:44:20Z"
}

variable "amis" {
  type = "map"

  default = {
    us-east-1      = "ami-ec33cc96"
    us-east-2      = "ami-34032e51"
    us-west-1      = "ami-d5d0e0b5"
    us-west-2      = "ami-29f80351"
    eu-west-2      = "ami-eb62708f"
    eu-west-1      = "ami-13f7226a"
    eu-central-1   = "ami-40d5672f"
    ap-northeast-2 = "ami-7ee13b10"
    ap-northeast-1 = "ami-21815747"
    ap-southeast-2 = "ami-4f08e82d"
    ap-southeast-1 = "ami-99f588fa"
    ca-central-1   = "ami-9b54edff"
  }
}

variable "subnet_ids" {
  type    = "list"
  default = []
}

variable "vpc_id" {}

variable "key_name" {}

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
