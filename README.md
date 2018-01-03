# terraform-aws-terraform

This a terraform module to create an autoscaling group that works together with Rancher. This module attaches and 
detaches AWS instances automatically. Rancher by default does not remove hosts (instances) that are not started up by 
Rancher. Therefore we use a Lambda script to tell Rancher server that an instance is no longer available.

## Features
- Automatically attaches instances to Rancher 
- Automatically removes instances from Rancher using a Lambda function

## Requirements
- Terraform CLI (v0.9.11)
- AWS account
- A running Rancher server
- A HTTP and HTTPS Load balancer

## Usage
Create a terraform [configuration](https://www.terraform.io/intro/getting-started/build.html#configuration) and include 
the following:

    module "autoscaling" {
      source              = "githuburl"
      environment         = "${var.environment}"

    }

Apply your Terraform configuration. 


