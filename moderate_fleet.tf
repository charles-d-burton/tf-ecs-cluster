#Generate the spot fleet request, loads Userdata to each instance to join it to the cluster
resource "aws_spot_fleet_request" "moderate_fleet" {
  iam_fleet_role      = "${aws_iam_role.spot_fleet_role.arn}"
  spot_price          = "${var.max_price}"
  allocation_strategy = "diversified"
  target_capacity     = "${var.cluster_size}"
  valid_until         = "${var.valid_until}"

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

  ######################
  #m4.large
  ######################
  launch_specification {
    instance_type          = "m4.large"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.12"
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
  #c4.large
  ######################
  launch_specification {
    instance_type          = "c4.large"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.12"
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
  #r4.large
  ######################
  launch_specification {
    instance_type          = "r4.large"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.15"
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
  #i3.large
  ######################
  launch_specification {
    instance_type          = "i3.large"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.17"
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
