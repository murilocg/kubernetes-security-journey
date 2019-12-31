include {
  path = find_in_parent_folders()
}

locals {
  path = "${find_in_parent_folders()}/../config/${get_env("ENVIRONMENT", "none")}"
  common = yamldecode(file("${local.path}/common.yaml"))
  cluster = yamldecode(file("${local.path}/cluster.yaml"))
}

inputs = {
  
  environment     = local.common.env.name
  region          = local.common.env.region
  cluster_name    = local.cluster.clusterName
  
  cidr            = local.common.vpc.cidr
  azs             = local.common.vpc.azs
  private_subnets = local.common.vpc.private_subnets
  public_subnets  = local.common.vpc.public_subnets

}
