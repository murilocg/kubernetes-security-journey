
terraform {

  before_hook "before_plan" {
    commands = ["plan"]
    execute = ["/bin/bash","-c","${get_terragrunt_dir()}/../kubernetes-cluster/export_kubeconfig.sh","${get_terragrunt_dir()}"]
    run_on_error = false
  }

  before_hook "gen_cert" {
    commands = ["plan"]
    execute = ["./gencerts.sh","${dependency.tiller.outputs.helm_client_tls_private_key_pem}",".client_key.pem"]
  }
  
  before_hook "gen_cert" {
    commands = ["plan"]
    execute = ["./gencerts.sh","${dependency.tiller.outputs.helm_client_tls_public_cert_pem}",".client_cert.pem"]
  }
  
  before_hook "gen_cert" {
    commands = ["plan"]
    execute = ["./gencerts.sh","${dependency.tiller.outputs.helm_client_tls_ca_cert_pem}",".ca.pem"]
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

