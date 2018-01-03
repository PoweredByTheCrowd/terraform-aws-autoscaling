data "aws_caller_identity" "current" {}
data "aws_region" "current" { current = true }

variable "environment" { default="autoscaling" }
variable "ami_id" { default = "" } # RancherOs
variable "instance_type" { default = "t2.micro" }
variable "name_prefix" { default = "autoscaling" }
variable "volume_size" { default = 8 }
variable "launch_config_min_size" { default = 1 }
variable "launch_config_max_size" { default = 3 }
variable "launch_config_desired_size" { default = 2 }

variable "security_groups" {
  type    = "list"
  default = [
    "sg-xxxxxxxx"
  ]
}
variable "private_subnet_ids" {
  type    = "list"
  default =   [
    "subnet-xxxxxxxx",
    "subnet-xxxxxxxx",
    "subnet-xxxxxxxx"
  ]
}

variable "rancher_agent_version"    { default = "v2.0-alpha4" }
variable "docker_version"           { default = "docker-1.12.6" }
variable "authorized_keys"          { default = "./authorized_keys/authorized_keys" }
variable "userdata_path"            { default = "./userdata/userdata.yml" }
variable "alb_target_group_http_arn" { default = "arn:aws:elasticloadbalancing:xx-xxx-x:XXXXXXXXXXXX:targetgroup/url-http/XXXXXXXXXXXXXXXX" }
variable "alb_target_group_https_arn" {default = "arn:aws:elasticloadbalancing:xx-xxx-x:XXXXXXXXXXXX:targetgroup/url-https/XXXXXXXXXXXXXXXX" }

variable "cleanup_rancher_script"   { default = "./files/cleanup_rancher.zip" }
variable "kms_description"          { default = "lambda autoscaling remove instance" }
variable "kms_purpose"              { default = "lambda_autoscaling" }
variable "rancher_registration_url" { default = "http://rancher-url/v3/scripts/XXXXXXXXXXXX:XXXXXXXXXXXX:XXXXXXXXXXXX" }
variable "rancher_api_url"          { default = "http://rancher-url/v3/projects/" }
variable "rancher_access_key"       { default = "XXXXXXXXXXXXXXXXXX" }
variable "rancher_secret_key"       { default = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" }
variable "rancher_project_id"       { default = "/XXX" }
