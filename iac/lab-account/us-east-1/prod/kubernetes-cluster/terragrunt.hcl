
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {

  before_hook "before_plan" {
    commands = ["plan"]
    execute = ["./render.sh","${get_terragrunt_dir()}","${local.common_vars.cluster_name}","${local.common_vars.kops_state_bucket}","${local.common_vars.public_zone_id}"]
    run_on_error = false
  }


}



include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../kubernetes-cluster-prereqs"]
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../kubernetes-cluster-vpc"

}

