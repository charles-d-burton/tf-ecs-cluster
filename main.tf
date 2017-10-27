#Generate the userdata script, this is what joins the nodes to the ECS cluster
data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.sh")}"

  vars {
    region       = "${var.region}"
    cluster_name = "ecs-${var.env}-${var.region}"

    //consul_dns   = "${var.consul_elb_address}"
  }
}

#Create the security group for network ingress/egress
resource "aws_security_group" "ecs_instance_security_group" {
  name        = "ecs-${var.env}-instance-sg"
  description = "Instance security group for ECS"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress {
    from_port   = 1
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = ["${data.aws_vpc.vpc.cidr_block}"]
  }

  /*
*  ingress {
*    from_port = 8300
*    to_port = 8600
*    protocol = "TCP"
*    security_groups = ["${var.consul_instance_sg}"]
*  }
*
*
*  ingress {
*    from_port       = 8300
*    to_port         = 8600
*    protocol        = "UDP"
*    security_groups = ["${var.consul_instance_sg}"]
*  }
*/

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create the ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-${var.env}-${var.region}"
}

#Generate the spot fleet request, loads Userdata to each instance to join it to the cluster
resource "aws_spot_fleet_request" "fleet" {
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
    spot_price             = "0.108"
    key_name               = "${var.env}-${var.region}"
    iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
    subnet_id              = "${data.aws_subnet_ids.ids[0]}"
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

  launch_specification {
    instance_type          = "m3.medium"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.108"
    key_name               = "${var.env}-${var.region}"
    iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
    subnet_id              = "${data.aws_subnet_ids.ids[1]}"
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

  launch_specification {
    instance_type          = "m3.medium"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.108"
    key_name               = "${var.env}-${var.region}"
    iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
    subnet_id              = "${data.aws_subnet_ids.ids[2]}"
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

  launch_specification {
    instance_type          = "m3.medium"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.108"
    key_name               = "${var.env}-${var.region}"
    iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
    subnet_id              = "${data.aws_subnet_ids.ids[3]}"
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

  launch_specification {
    instance_type          = "m3.medium"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.108"
    key_name               = "${var.env}-${var.region}"
    iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
    subnet_id              = "${data.aws_subnet_ids.ids[4]}"
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

  launch_specification {
    instance_type          = "m3.medium"
    ami                    = "${lookup(var.amis, var.region)}"
    spot_price             = "0.108"
    key_name               = "${var.env}-${var.region}"
    iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
    subnet_id              = "${data.aws_subnet_ids.ids[5]}"
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
  #M4.xlarge
  ######################
  /*  launch_specification {
                              instance_type          = "m4.xlarge"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.150"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[0]}"
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

                            launch_specification {
                              instance_type          = "m4.xlarge"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.150"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[1]}"
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

                            launch_specification {
                              instance_type          = "m4.xlarge"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.150"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[2]}"
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
                            #C4.large
                            ######################
                            launch_specification {
                              instance_type          = "c4.large"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.1"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[0]}"
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

                            launch_specification {
                              instance_type          = "c4.large"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.1"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[1]}"
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

                            launch_specification {
                              instance_type          = "c4.large"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.1"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[2]}"
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
                            #C4.xlarge
                            ######################

                            launch_specification {
                              instance_type          = "c4.xlarge"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.150"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[0]}"
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
                            launch_specification {
                              instance_type          = "c4.xlarge"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.150"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[1]}"
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
                            launch_specification {
                              instance_type          = "c4.xlarge"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.150"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[2]}"
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
                            #R4.large
                            ######################
                            launch_specification {
                              instance_type          = "r4.large"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.133"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[0]}"
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
                            launch_specification {
                              instance_type          = "r4.large"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.133"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[1]}"
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
                            launch_specification {
                              instance_type          = "r4.large"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.133"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[2]}"
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
                            #R4.xlarge
                            ######################
                            launch_specification {
                              instance_type          = "r4.xlarge"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.150"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[0]}"
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
                            launch_specification {
                              instance_type          = "r4.xlarge"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.150"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[1]}"
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
                            launch_specification {
                              instance_type          = "r4.xlarge"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.150"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[2]}"
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
                              spot_price             = "0.156"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[0]}"
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
                            launch_specification {
                              instance_type          = "i3.large"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.156"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[1]}"
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
                            launch_specification {
                              instance_type          = "i3.large"
                              ami                    = "${lookup(var.amis, var.region)}"
                              spot_price             = "0.156"
                              key_name               = "${var.key_name}"
                              iam_instance_profile   = "${aws_iam_instance_profile.ecs.name}"
                              subnet_id              = "${data.aws_subnet_ids.ids[2]}"
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
                            } */
  depends_on = ["aws_iam_role.spot_instance_role", "aws_iam_role.spot_fleet_role"]
}
