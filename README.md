AWS ECS Spot Fleet Request
=================================

Terraform module which creates an autoscaling Spot Fleet and an ECS Cluster on AWS.


Usage
-----

```hcl
module "ecs_request" {
  source = "git@github.com:charles-d-burton/tf_ecs_cluster.git"
  region       = "us-east-1"
  env          = "dev"
  cluster_size = "5"
  vpc_id       = "<your vpc>"
  subnet_ids   = [<list of subnets>]
  key_name     = "dev"

  notification = ["arn:aws:sns:us-east-1:1234567890:no-alarm"]
}
```

Limitations
-----------

* some instance types cannot be launched in certain regions.

Authors
-------

Module managed by [Charles Burton](https://github.com/charles-d-burton).

License
-------

Apache 2 Licensed. See LICENSE for full details.