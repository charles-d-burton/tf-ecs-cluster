#TODO: Fix all outputs to align with fleet types

output "instance_sg_id" {
  value = "${aws_security_group.ecs_instance_security_group.id}"
}

output "instance_sg_name" {
  value = "${aws_security_group.ecs_instance_security_group.name}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.ecs_cluster.name}"
}

output "cluster_arn" {
  value = "${aws_ecs_cluster.ecs_cluster.id}"
}

output "fleet_request_id" {
  value = "${join("", aws_spot_fleet_request.us_east1_fleet.*.id)}"
}
