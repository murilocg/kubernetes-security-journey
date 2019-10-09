

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../../kubernetes-cluster"]
}

dependency "tiller" {
  config_path = "${get_terragrunt_dir()}/../../kubernetes-tiller"
}

