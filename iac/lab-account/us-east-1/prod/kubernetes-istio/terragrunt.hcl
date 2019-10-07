
terraform {

  before_hook "before_plan" {
    commands = ["plan"]
    execute = ["/bin/bash","-c","${get_terragrunt_dir()}/../kubernetes-cluster/export_kubeconfig.sh","${get_terragrunt_dir()}"]
    run_on_error = false
  }

  before_hook "gen_cert" {
    commands = ["plan"]
    execute = ["./gencerts.sh"]
  }
  
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../kubernetes-cluster"]
}

dependency "tiller" {
  config_path = "${get_terragrunt_dir()}/../kubernetes-tiller"
}

