locals {
  cluster_name                 = "journey.dev.local"
  master_autoscaling_group_ids = [aws_autoscaling_group.master-ig-masters-journey-dev-local.id]
  master_security_group_ids    = [aws_security_group.masters-journey-dev-local.id]
  masters_role_arn             = aws_iam_role.masters-journey-dev-local.arn
  masters_role_name            = aws_iam_role.masters-journey-dev-local.name
  node_autoscaling_group_ids   = [aws_autoscaling_group.nodes-journey-dev-local.id]
  node_security_group_ids      = [aws_security_group.nodes-journey-dev-local.id]
  node_subnet_ids              = ["subnet-002879c91022ebe0e", "subnet-00a4ef8be467af3ab", "subnet-09eb91a443dd3b783"]
  nodes_role_arn               = aws_iam_role.nodes-journey-dev-local.arn
  nodes_role_name              = aws_iam_role.nodes-journey-dev-local.name
  region                       = "us-east-1"
  subnet_ids                   = ["subnet-002879c91022ebe0e", "subnet-00a4ef8be467af3ab", "subnet-04980a7d1367dee67", "subnet-05c7d1adb8eaa5814", "subnet-05f0606ea5b91c22b", "subnet-09eb91a443dd3b783"]
  subnet_private-us-east-1a_id = "subnet-00a4ef8be467af3ab"
  subnet_private-us-east-1b_id = "subnet-002879c91022ebe0e"
  subnet_private-us-east-1c_id = "subnet-09eb91a443dd3b783"
  subnet_utility-us-east-1a_id = "subnet-04980a7d1367dee67"
  subnet_utility-us-east-1b_id = "subnet-05c7d1adb8eaa5814"
  subnet_utility-us-east-1c_id = "subnet-05f0606ea5b91c22b"
  vpc_id                       = "vpc-06c5650b8338e29ee"
}

output "cluster_name" {
  value = "journey.dev.local"
}

output "master_autoscaling_group_ids" {
  value = [aws_autoscaling_group.master-ig-masters-journey-dev-local.id]
}

output "master_security_group_ids" {
  value = [aws_security_group.masters-journey-dev-local.id]
}

output "masters_role_arn" {
  value = aws_iam_role.masters-journey-dev-local.arn
}

output "masters_role_name" {
  value = aws_iam_role.masters-journey-dev-local.name
}

output "node_autoscaling_group_ids" {
  value = [aws_autoscaling_group.nodes-journey-dev-local.id]
}

output "node_security_group_ids" {
  value = [aws_security_group.nodes-journey-dev-local.id]
}

output "node_subnet_ids" {
  value = ["subnet-002879c91022ebe0e", "subnet-00a4ef8be467af3ab", "subnet-09eb91a443dd3b783"]
}

output "nodes_role_arn" {
  value = aws_iam_role.nodes-journey-dev-local.arn
}

output "nodes_role_name" {
  value = aws_iam_role.nodes-journey-dev-local.name
}

output "region" {
  value = "us-east-1"
}

output "subnet_ids" {
  value = ["subnet-002879c91022ebe0e", "subnet-00a4ef8be467af3ab", "subnet-04980a7d1367dee67", "subnet-05c7d1adb8eaa5814", "subnet-05f0606ea5b91c22b", "subnet-09eb91a443dd3b783"]
}

output "subnet_private-us-east-1a_id" {
  value = "subnet-00a4ef8be467af3ab"
}

output "subnet_private-us-east-1b_id" {
  value = "subnet-002879c91022ebe0e"
}

output "subnet_private-us-east-1c_id" {
  value = "subnet-09eb91a443dd3b783"
}

output "subnet_utility-us-east-1a_id" {
  value = "subnet-04980a7d1367dee67"
}

output "subnet_utility-us-east-1b_id" {
  value = "subnet-05c7d1adb8eaa5814"
}

output "subnet_utility-us-east-1c_id" {
  value = "subnet-05f0606ea5b91c22b"
}

output "vpc_id" {
  value = "vpc-06c5650b8338e29ee"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_autoscaling_attachment" "master-ig-masters-journey-dev-local" {
  elb                    = aws_elb.api-journey-dev-local.id
  autoscaling_group_name = aws_autoscaling_group.master-ig-masters-journey-dev-local.id
}

resource "aws_autoscaling_group" "master-ig-masters-journey-dev-local" {
  name     = "master-ig.masters.journey.dev.local"
  max_size = 1
  min_size = 1

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.master-ig-masters-journey-dev-local.id
        version            = aws_launch_template.master-ig-masters-journey-dev-local.latest_version
      }

      override {
        instance_type = "m5.large"
      }

      override {
        instance_type = "t3.medium"
      }

      override {
        instance_type = "c4.large"
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_instance_pools                      = 3
    }
  }

  vpc_zone_identifier = ["subnet-00a4ef8be467af3ab"]

  tag {
    key                 = "KubernetesCluster"
    value               = "journey.dev.local"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "master-ig.masters.journey.dev.local"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "dev"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-ig"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  tag {
    key                 = "owner"
    value               = "journey.dev.local"
    propagate_at_launch = true
  }

  tag {
    key                 = "solution"
    value               = "kubernetes"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-journey-dev-local" {
  name     = "nodes.journey.dev.local"
  max_size = 3
  min_size = 3

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.nodes-journey-dev-local.id
        version            = aws_launch_template.nodes-journey-dev-local.latest_version
      }

      override {
        instance_type = "m5.large"
      }

      override {
        instance_type = "t3.medium"
      }

      override {
        instance_type = "c4.large"
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_instance_pools                      = 3
    }
  }

  vpc_zone_identifier = ["subnet-00a4ef8be467af3ab", "subnet-002879c91022ebe0e", "subnet-09eb91a443dd3b783"]

  tag {
    key                 = "KubernetesCluster"
    value               = "journey.dev.local"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "nodes.journey.dev.local"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "dev"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  tag {
    key                 = "owner"
    value               = "journey.dev.local"
    propagate_at_launch = true
  }

  tag {
    key                 = "solution"
    value               = "kubernetes"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_ebs_volume" "a-etcd-events-journey-dev-local" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                         = "journey.dev.local"
    Name                                      = "a.etcd-events.journey.dev.local"
    environment                               = "dev"
    "k8s.io/etcd/events"                      = "a/a"
    "k8s.io/role/master"                      = "1"
    "kubernetes.io/cluster/journey.dev.local" = "owned"
    owner                                     = "journey.dev.local"
    solution                                  = "kubernetes"
  }
}

resource "aws_ebs_volume" "a-etcd-main-journey-dev-local" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                         = "journey.dev.local"
    Name                                      = "a.etcd-main.journey.dev.local"
    environment                               = "dev"
    "k8s.io/etcd/main"                        = "a/a"
    "k8s.io/role/master"                      = "1"
    "kubernetes.io/cluster/journey.dev.local" = "owned"
    owner                                     = "journey.dev.local"
    solution                                  = "kubernetes"
  }
}

resource "aws_elb" "api-journey-dev-local" {
  name = "api-journey-dev-local-q15jo9"

  listener {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }

  security_groups = [aws_security_group.api-elb-journey-dev-local.id, "sg-068c7d2715eb5fc77"]
  subnets         = ["subnet-04980a7d1367dee67", "subnet-05c7d1adb8eaa5814", "subnet-05f0606ea5b91c22b"]

  health_check {
    target              = "SSL:443"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5
  }

  cross_zone_load_balancing = false
  idle_timeout              = 300

  tags = {
    KubernetesCluster                         = "journey.dev.local"
    Name                                      = "api.journey.dev.local"
    environment                               = "dev"
    "kubernetes.io/cluster/journey.dev.local" = "owned"
    owner                                     = "journey.dev.local"
    solution                                  = "kubernetes"
  }
}

resource "aws_iam_instance_profile" "masters-journey-dev-local" {
  name = "masters.journey.dev.local"
  role = aws_iam_role.masters-journey-dev-local.name
}

resource "aws_iam_instance_profile" "nodes-journey-dev-local" {
  name = "nodes.journey.dev.local"
  role = aws_iam_role.nodes-journey-dev-local.name
}

resource "aws_iam_role" "masters-journey-dev-local" {
  name = "masters.journey.dev.local"
  assume_role_policy = file(
    "${path.module}/data/aws_iam_role_masters.journey.dev.local_policy",
  )
}

resource "aws_iam_role" "nodes-journey-dev-local" {
  name = "nodes.journey.dev.local"
  assume_role_policy = file(
    "${path.module}/data/aws_iam_role_nodes.journey.dev.local_policy",
  )
}

resource "aws_iam_role_policy" "additional-nodes-journey-dev-local" {
  name = "additional.nodes.journey.dev.local"
  role = aws_iam_role.nodes-journey-dev-local.name
  policy = file(
    "${path.module}/data/aws_iam_role_policy_additional.nodes.journey.dev.local_policy",
  )
}

resource "aws_iam_role_policy" "masters-journey-dev-local" {
  name = "masters.journey.dev.local"
  role = aws_iam_role.masters-journey-dev-local.name
  policy = file(
    "${path.module}/data/aws_iam_role_policy_masters.journey.dev.local_policy",
  )
}

resource "aws_iam_role_policy" "nodes-journey-dev-local" {
  name = "nodes.journey.dev.local"
  role = aws_iam_role.nodes-journey-dev-local.name
  policy = file(
    "${path.module}/data/aws_iam_role_policy_nodes.journey.dev.local_policy",
  )
}

resource "aws_key_pair" "kubernetes-journey-dev-local-59729192f8c74f680b63f8574029b877" {
  key_name = "kubernetes.journey.dev.local-59:72:91:92:f8:c7:4f:68:0b:63:f8:57:40:29:b8:77"
  public_key = file(
    "${path.module}/data/aws_key_pair_kubernetes.journey.dev.local-59729192f8c74f680b63f8574029b877_public_key",
  )
}

resource "aws_launch_template" "master-ig-masters-journey-dev-local" {
  name_prefix = "master-ig.masters.journey.dev.local-"

  lifecycle {
    create_before_destroy = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp2"
      volume_size           = 64
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.masters-journey-dev-local.id
  }

  image_id      = "ami-077b21be2bc9db012"
  instance_type = "t3.medium"
  key_name      = aws_key_pair.kubernetes-journey-dev-local-59729192f8c74f680b63f8574029b877.id

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [aws_security_group.masters-journey-dev-local.id]
  }

  user_data = file(
    "${path.module}/data/aws_launch_template_master-ig.masters.journey.dev.local_user_data",
  )
}

resource "aws_launch_template" "nodes-journey-dev-local" {
  name_prefix = "nodes.journey.dev.local-"

  lifecycle {
    create_before_destroy = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp2"
      volume_size           = 128
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.nodes-journey-dev-local.id
  }

  image_id      = "ami-077b21be2bc9db012"
  instance_type = "t3.large"
  key_name      = aws_key_pair.kubernetes-journey-dev-local-59729192f8c74f680b63f8574029b877.id

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [aws_security_group.nodes-journey-dev-local.id]
  }

  user_data = file(
    "${path.module}/data/aws_launch_template_nodes.journey.dev.local_user_data",
  )
}

resource "aws_route53_record" "api-journey-dev-local" {
  name = "api.journey.dev.local"
  type = "A"

  alias {
    name                   = aws_elb.api-journey-dev-local.dns_name
    zone_id                = aws_elb.api-journey-dev-local.zone_id
    evaluate_target_health = false
  }

  zone_id = "/hostedzone/Z0431749VSGUS8C691ZF"
}

resource "aws_security_group" "api-elb-journey-dev-local" {
  name        = "api-elb.journey.dev.local"
  vpc_id      = "vpc-06c5650b8338e29ee"
  description = "Security group for api ELB"

  tags = {
    KubernetesCluster                         = "journey.dev.local"
    Name                                      = "api-elb.journey.dev.local"
    "kubernetes.io/cluster/journey.dev.local" = "owned"
  }
}

resource "aws_security_group" "masters-journey-dev-local" {
  name        = "masters.journey.dev.local"
  vpc_id      = "vpc-06c5650b8338e29ee"
  description = "Security group for masters"

  tags = {
    KubernetesCluster                         = "journey.dev.local"
    Name                                      = "masters.journey.dev.local"
    "kubernetes.io/cluster/journey.dev.local" = "owned"
  }
}

resource "aws_security_group" "nodes-journey-dev-local" {
  name        = "nodes.journey.dev.local"
  vpc_id      = "vpc-06c5650b8338e29ee"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster                         = "journey.dev.local"
    Name                                      = "nodes.journey.dev.local"
    "kubernetes.io/cluster/journey.dev.local" = "owned"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-journey-dev-local.id
  source_security_group_id = aws_security_group.masters-journey-dev-local.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = aws_security_group.nodes-journey-dev-local.id
  source_security_group_id = aws_security_group.masters-journey-dev-local.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = aws_security_group.nodes-journey-dev-local.id
  source_security_group_id = aws_security_group.nodes-journey-dev-local.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "api-elb-egress" {
  type              = "egress"
  security_group_id = aws_security_group.api-elb-journey-dev-local.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-api-elb-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = aws_security_group.api-elb-journey-dev-local.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-elb-to-master" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-journey-dev-local.id
  source_security_group_id = aws_security_group.api-elb-journey-dev-local.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "icmp-pmtu-api-elb-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = aws_security_group.api-elb-journey-dev-local.id
  from_port         = 3
  to_port           = 4
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = aws_security_group.masters-journey-dev-local.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = aws_security_group.nodes-journey-dev-local.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-protocol-ipip" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-journey-dev-local.id
  source_security_group_id = aws_security_group.nodes-journey-dev-local.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "4"
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-journey-dev-local.id
  source_security_group_id = aws_security_group.nodes-journey-dev-local.id
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4001" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-journey-dev-local.id
  source_security_group_id = aws_security_group.nodes-journey-dev-local.id
  from_port                = 2382
  to_port                  = 4001
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-journey-dev-local.id
  source_security_group_id = aws_security_group.nodes-journey-dev-local.id
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-journey-dev-local.id
  source_security_group_id = aws_security_group.nodes-journey-dev-local.id
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = aws_security_group.masters-journey-dev-local.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = aws_security_group.nodes-journey-dev-local.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

terraform {
  required_version = ">= 0.9.3"
}

