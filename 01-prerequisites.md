# Prerequisites

## AWS

This tutorial leverages the [Amazon AWS](https://aws.amazon.com/) to streamline provisioning of the compute infrastructure required to bootstrap a Kubernetes cluster using kops. [Sign up](https://https://aws.amazon.com/) to create an account.

> The compute resources required for this tutorial exceed the AWS free tier.

## AWS CLI

### Install the AWS CLI command line tool

Follow the AWS CLI User guide to [install](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
and [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) the `aws` command line utility.

Verify the AWS CLI version is 1.16.240 or higher:

```
aws --version
```

### AWS Vault

AWS Vault is a tool to securely store and access AWS credentials in a development environment.

AWS Vault stores IAM credentials in your operating system's secure keystore and then generates temporary credentials from those to expose to your shell and applications. 
It's designed to be complementary to the AWS CLI tools, and is aware of your [profiles and configuration in `~/.aws/config`](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-config-files).

See the [complete description](https://github.com/99designs/aws-vault)


Next: [Installing the Client Tools](02-client-tools.md)
