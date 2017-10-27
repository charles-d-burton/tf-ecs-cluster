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
    us-east-1 = "ami-ec33cc96"
    us-east-2 = "ami-34032e51"
    us-west-1 = "ami-d5d0e0b5"
    us-west-2 = "ami-29f80351"
  }
}

variable "subnets" {
  type = "list"
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

variable "CPUUtil_metric_name" {
  default = ""
}

variable "CPUUtil_period" {
  default = 60
}

variable "CPUUtil_evaluation_periods" {
  default = 2
}

variable "CPUUtil_threshold" {
  default = 2
}

variable "CPUUtil_namespace" {
  default = "AWS/ECS"
}

variable "CPUUtil_comparison_operator" {
  default = "GreaterThanOrEqualToThreshold"
}

variable "CPUUtil_statistic" {
  default = "Average"
}

variable "MemoryUtil_metric_name" {
  default = ""
}

variable "MemoryUtil_period" {
  default = 60
}

variable "MemoryUtil_evaluation_periods" {
  default = 2
}

variable "MemoryUtil_threshold" {
  default = 2
}

variable "MemoryUtil_namespace" {
  default = "AWS/ECS"
}

variable "MemoryUtil_comparison_operator" {
  default = "GreaterThanOrEqualToThreshold"
}

variable "MemoryUtil_statistic" {
  default = "Average"
}

variable "notification" {
  default = ["arn:aws:sns:us-west-2:1234567890:no-alarm"]
}
