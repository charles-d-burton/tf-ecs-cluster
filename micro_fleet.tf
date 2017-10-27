#Generate the spot fleet request, loads Userdata to each instance to join it to the cluster
#########################
####THIS FLEET TYPE ONLY AVAILABLE IN us-east-1, us-west-2, and us-west-1
##########################
resource "aws_spot_fleet_request" "micro_fleet" {
  iam_fleet_role      = "${aws_iam_role.spot_fleet_role.arn}"
  spot_price          = "${var.max_price}"
  allocation_strategy = "lowest_price"
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
      snapshot_id           = "snap-adca7883"
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
      snapshot_id           = "snap-adca7883"
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
