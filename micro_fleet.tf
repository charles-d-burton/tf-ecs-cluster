#Generate the spot fleet request, loads Userdata to each instance to join it to the cluster
#########################
####THIS FLEET TYPE ONLY AVAILABLE IN us-east-1, us-west-2, and us-west-1
##########################
resource "aws_spot_fleet_request" "micro_fleet" {
  count               = "${var.micro_fleet}"
  iam_fleet_role      = "${aws_iam_role.spot_fleet_role.arn}"
  spot_price          = "${var.max_price}"
  allocation_strategy = "lowestPrice"
  target_capacity     = "${var.cluster_size}"
  valid_until         = "${var.valid_until}"

  ######################
  #t1.micro
  ######################
  launch_specification {
    instance_type          = "t1.micro"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.01"
    key_name               = "${var.env}-${var.region}"
    iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
    subnet_id              = "${join(",", var.subnet_ids)}"
    vpc_security_group_ids = ["${aws_security_group.ecs_instance_security_group.id}"]

    ebs_block_device = {
      volume_type           = "gp2"
      volume_size           = "8"
      delete_on_termination = "true"
      device_name           = "/dev/xvda"
    }

    ebs_block_device = {
      volume_type           = "gp2"
      volume_size           = "${var.volume_size}"
      delete_on_termination = "true"
      device_name           = "/dev/xvdcz"
    }

    user_data = "${data.template_file.userdata.rendered}"
  }

  ######################
  #m3.medium
  ######################
  launch_specification {
    instance_type          = "m3.medium"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.067"
    key_name               = "${var.env}-${var.region}"
    iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
    subnet_id              = "${join(",", var.subnet_ids)}"
    vpc_security_group_ids = ["${aws_security_group.ecs_instance_security_group.id}"]

    ebs_block_device = {
      volume_type           = "gp2"
      volume_size           = "8"
      delete_on_termination = "true"
      device_name           = "/dev/xvda"
    }

    ebs_block_device = {
      volume_type           = "gp2"
      volume_size           = "${var.volume_size}"
      delete_on_termination = "true"
      device_name           = "/dev/xvdcz"
    }

    user_data = "${data.template_file.userdata.rendered}"
  }

  depends_on = ["aws_iam_role.spot_instance_role", "aws_iam_role.spot_fleet_role"]
}

#Cloudwatch autoscaling and monitoring
resource "aws_cloudwatch_metric_alarm" "micro_fleet_ecs_cluster_cpu_util_cloudwatch" {
  count               = "${var.micro_fleet}"
  alarm_name          = "ecs-${var.env}-${var.region} ${var.cpu_util_metric_name}"
  comparison_operator = "${var.cpu_util_comparison_operator}"
  evaluation_periods  = "${var.cpu_util_evaluation_periods}"
  metric_name         = "${var.cpu_util_metric_name}"
  namespace           = "${var.cpu_util_namespace}"
  period              = "${var.cpu_util_period}"
  statistic           = "${var.cpu_util_statistic}"
  threshold           = "${var.cpu_util_threshold}"
  alarm_actions       = "${var.notification}"

  alarm_description = "CloudWatch metric alarm: ecs-${var.env}-${var.region} ${var.cpu_util_metric_name} ${var.cpu_util_comparison_operator}"

  dimensions {
    ClusterName = "ecs-${var.env}-${var.region}"
  }
}

resource "aws_cloudwatch_metric_alarm" "micro_fleet_ecs_cluster_mem_util_cloudwatch" {
  count               = "${var.micro_fleet}"
  alarm_name          = "ecs-${var.env}-${var.region} ${var.memory_util_metric_name}"
  comparison_operator = "${var.memory_util_comparison_operator}"
  evaluation_periods  = "${var.memory_util_evaluation_periods}"
  metric_name         = "${var.memory_util_metric_name}"
  namespace           = "${var.memory_util_namespace}"
  period              = "${var.memory_util_period}"
  statistic           = "${var.memory_util_statistic}"
  threshold           = "${var.memory_util_threshold}"
  alarm_actions       = "${var.notification}"

  alarm_description = "CloudWatch metric alarm: ecs-${var.env}-${var.region} ${var.memory_util_metric_name} ${var.memory_util_comparison_operator}"

  dimensions {
    ClusterName = "ecs-${var.env}-${var.region}"
  }
}

resource "aws_appautoscaling_target" "micro_fleet_service_target" {
  count              = "${var.micro_fleet}"
  max_capacity       = 50
  min_capacity       = "${var.cluster_size}"
  resource_id        = "spot-fleet-request/${aws_spot_fleet_request.micro_fleet.id}"
  role_arn           = "${aws_iam_role.autoscaling_role.arn}"
  scalable_dimension = "ec2:spot-fleet-request:TargetCapacity"
  service_namespace  = "ec2"
}

resource "aws_appautoscaling_policy" "micro_fleet_service_down_policy" {
  count              = "${var.micro_fleet}"
  name               = "scale-down-ecs-${var.env}-${var.region}"
  resource_id        = "spot-fleet-request/${aws_spot_fleet_request.micro_fleet.id}"
  scalable_dimension = "ec2:spot-fleet-request:TargetCapacity"
  service_namespace  = "ec2"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Minimum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -2
    }
  }

  depends_on = ["aws_appautoscaling_target.micro_fleet_service_target"]
}

resource "aws_appautoscaling_policy" "micro_fleet_service_up_policy" {
  count              = "${var.micro_fleet}"
  name               = "scale-up-ecs-${var.env}-${var.region}"
  resource_id        = "spot-fleet-request/${aws_spot_fleet_request.micro_fleet.id}"
  scalable_dimension = "ec2:spot-fleet-request:TargetCapacity"
  service_namespace  = "ec2"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 5
    }
  }

  depends_on = ["aws_appautoscaling_target.micro_fleet_service_target"]
}

resource "aws_cloudwatch_metric_alarm" "micro_fleet_service_highcpu_scaleup" {
  count               = "${var.micro_fleet}"
  alarm_name          = "ecs-${var.env}-${var.region}-scaleup"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  alarm_description = "CPU Autoscaling alarm to scale up"

  dimensions {
    ClusterName = "ecs-${var.env}-${var.region}"
  }

  alarm_actions = [
    "${aws_appautoscaling_policy.micro_fleet_service_up_policy.arn}",
  ]

  depends_on = ["aws_appautoscaling_policy.micro_fleet_service_up_policy"]
}

resource "aws_cloudwatch_metric_alarm" "micro_fleet_service_highcpu_scaledown" {
  count               = "${var.micro_fleet}"
  alarm_name          = "ecs-${var.env}-${var.region}-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  alarm_description = "CPU Autoscaling alarm to scale down"

  dimensions {
    ClusterName = "ecs-${var.env}-${var.region}"
  }

  alarm_actions = [
    "arn:aws:sns:${var.region}:1234567890:no-alarm",
  ]

  depends_on = ["aws_appautoscaling_policy.micro_fleet_service_down_policy"]
}
