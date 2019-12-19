
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}


terraform {
 
}

include {
  path = find_in_parent_folders()
}
