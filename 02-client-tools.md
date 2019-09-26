# Installing the Client Tools

In this lab you will install the command line utilities required to complete this tutorial:

* [Kops](https://github.com/kubernetes/kops)
* [Terraform](https://www.terraform.io/intro/index.html)
* [Terragrunt](https://github.com/gruntwork-io/terragrunt)

## Terraform

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

### OS X
```
brew install terraform
```

### Verification

Verify `terraform` version v0.12.9 or higher is installed:

```
terraform version
```

> output

```
Terraform v0.12.9
```

## Terragrunt

Terragrunt is a thin wrapper for [Terraform](https://www.terraform.io/) that provides extra tools for keeping your 
Terraform configurations DRY, working with multiple Terraform modules, and managing remote state. Check out
[Terragrunt: how to keep your Terraform code DRY and 
maintainable](https://blog.gruntwork.io/terragrunt-how-to-keep-your-terraform-code-dry-and-maintainable-f61ae06959d8) 
for a quick introduction to Terragrunt. 

### OS X
```
brew install terragrunt
```

### Verification

Verify `terragrunt` version v0.19.16 or higher is installed:

```
terragrunt --version
```

> output

```
terragrunt version v0.19.16
```


## Kops

`kops` helps you create, destroy, upgrade and maintain production-grade, highly
available, Kubernetes clusters from the command line. AWS (Amazon Web Services)
is currently officially supported, with GCE and OpenStack in beta support, and VMware vSphere
in alpha, and other platforms planned.


### OS X

```
brew install kops
```

### Verification

Verify `kops` version 1.13.1 or higher is installed:

```
kops version
```

> output

```
Version 1.13.1
```

