# Provisioning Compute Resources

## Setup for terraform

You need to modify the [terragrunt configuration file](iac/lab-account/terragrunt.hcl) and replace the bucket property. The first time you run terragrunt plan / apply the bucket will be created in your aws account.

```
remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = < customize here >
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terragrunt-journey-terraform-locks"
  }
}
```

## Terraform: Shared resources
We need to setup some resources that will be used by kops for creating our k8s cluster but could also be used by other things.

We will use the very good [terraform-aws-vpc](https://github.com/terraform-aws-modules/) module to avoid having to setup each resource individually.

But first, let’s define some locals variables that will be used throughout the whole lab.

[lab-account/us-east-1/prod/common_vars.yaml](lab-account/us-east-1/prod/common_vars.yaml):

```
region:  "us-east-1"
cluster_name: "journey.dev.local"
cidr: "10.0.0.0/16"
azs:
  - "us-east-1a"
  - "us-east-1b"
  - "us-east-1c"
private_subnets:
  - "10.0.1.0/24"
  - "10.0.2.0/24"
  - "10.0.3.0/24"
public_subnets:
  - "10.0.101.0/24"
  - "10.0.102.0/24"
  - "10.0.103.0/24"
environment: "tutorial"
ingress_ips:
  - "10.0.0.100/32"
  - "10.0.0.101/32"
```

Those parameters are passed to the multiple projects:
* lab-account/us-east-1/prod/kubernetes-cluster-vpc: setups a new AWS VPC with public and private subnets
* lab-account/us-east-1/prod/kubernetes-cluster: depends on `kubernetes-cluster-vpc` and install kubernetes in this brand new AWS VPC
