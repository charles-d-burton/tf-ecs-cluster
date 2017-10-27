# Create the IAM Roles
resource "aws_iam_instance_profile" "ecs" {
  name = "ecs-instance-${var.region}"
  role = "${aws_iam_role.spot_instance_role.name}"
}

resource "aws_iam_role" "spot_fleet_role" {
  name = "spot_fleet_role_${var.region}"

  assume_role_policy = "${data.aws_iam_policy_document.spot_fleet_role_policy.json}"
}

resource "aws_iam_role" "spot_instance_role" {
  name = "spot_instance_role_${var.region}"

  assume_role_policy = "${data.aws_iam_policy_document.spot_instance_role_policy.json}"
}

resource "aws_iam_policy" "autoscaling_policy" {
  name   = "autoscaling-ecs-${var.env}-${var.region}"
  policy = "${data.aws_iam_policy_document.spot_fleet_autoscaling_policy.json}"
}

resource "aws_iam_role" "autoscaling_role" {
  name               = "tf-autoscaling-${var.env}-${var.region}"
  assume_role_policy = "${data.aws_iam_policy_document.spot_fleet_autoscaling_role.json}"
}

resource "aws_iam_policy_attachment" "autoscaling_attachment" {
  name       = "tf-autoscaling-attachment-${var.env}-${var.region}"
  policy_arn = "${aws_iam_policy.autoscaling_policy.arn}"
  roles      = ["${aws_iam_role.autoscaling_role.name}"]
}

#Create the IAM Policies
resource "aws_iam_policy" "spot_fleet_policy" {
  name   = "spot-fleet-policy-${var.region}"
  policy = "${data.aws_iam_policy_document.spot_fleet_policy.json}"
}

resource "aws_iam_policy" "spot_instance_policy" {
  name   = "spot-instance-policy-${var.region}"
  policy = "${data.aws_iam_policy_document.spot_fleet_instance_policy.json}"
}

#Attach policies to roles
resource "aws_iam_policy_attachment" "fleet_attachment" {
  name       = "fleet-attachment"
  policy_arn = "${aws_iam_policy.spot_fleet_policy.arn}"
  roles      = ["${aws_iam_role.spot_fleet_role.name}"]
}

resource "aws_iam_policy_attachment" "instance_attachment" {
  name       = "instance-attachment"
  policy_arn = "${aws_iam_policy.spot_instance_policy.arn}"
  roles      = ["${aws_iam_role.spot_instance_role.name}"]
}
