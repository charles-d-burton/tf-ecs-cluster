#Cloudwatch autoscaling and monitoring
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_cpu_util_cloudwatch" {
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

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_mem_util_cloudwatch" {
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

resource "aws_appautoscaling_target" "service_target" {
  max_capacity       = 50
  min_capacity       = "${var.cluster_size}"
  resource_id        = "spot-fleet-request/${aws_spot_fleet_request.fleet.id}"
  role_arn           = "${aws_iam_role.autoscaling_role.arn}"
  scalable_dimension = "ec2:spot-fleet-request:TargetCapacity"
  service_namespace  = "ec2"
}

resource "aws_appautoscaling_policy" "service_down_policy" {
  name               = "scale-down-ecs-${var.env}-${var.region}"
  resource_id        = "spot-fleet-request/${aws_spot_fleet_request.fleet.id}"
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

  depends_on = ["aws_appautoscaling_target.service_target"]
}

resource "aws_appautoscaling_policy" "service_up_policy" {
  name               = "scale-up-ecs-${var.env}-${var.region}"
  resource_id        = "spot-fleet-request/${aws_spot_fleet_request.fleet.id}"
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

  depends_on = ["aws_appautoscaling_target.service_target"]
}

resource "aws_cloudwatch_metric_alarm" "service_highcpu_scaleup" {
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
    "${aws_appautoscaling_policy.service_up_policy.arn}",
  ]

  depends_on = ["aws_appautoscaling_policy.service_up_policy"]
}

resource "aws_cloudwatch_metric_alarm" "service_highcpu_scaledown" {
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
    "${aws_appautoscaling_policy.service_down_policy.arn}",
  ]

  depends_on = ["aws_appautoscaling_policy.service_down_policy"]
}
