include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

inputs = {
  
  environment = local.common.environment
  cluster_name = local.common.cluster_name
  region = local.common.region
  
  cidr = "10.0.0.0/16"
  azs             = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
  private_subnets = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
  public_subnets  = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
