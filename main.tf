terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.26.0"
    }
  }
}

provider "aws" {
  region = var.autoscale_region
 }

module "autoscale" {

  # Since the terraform-up-and-running-code repo is open source, we're using an HTTPS URL here. If it was a private
  # repo, we'd instead use an SSH URL (git@github.com:brikis98/terraform-up-and-running-code.git) to leverage SSH auth
  source = "git::https://github.com/raj00565/terraform-modules-autoscale.git?ref=v1.0.4"

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = module.autoscale.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = module.autoscale.asg_name
}
