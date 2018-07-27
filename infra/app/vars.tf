# S3 bucket doesn't need to have static website feature enabled
# Best practice to use private bucket with Cloudfront origin access identity
variable "s3_origin_bucket" {
  description = "S3 bucket domain for cloudfront origin"
}

variable "cf_origin_id" {
  description = "User provided unique id for cloudfront distribution"
}

variable "domain_name" {
  description = "Naked domain name of your website"
}

# This would be mostly used in comments
variable "webapp_desc" {
  description = "Short description for your website"
}

variable "s3_log_bucket" {
  description = "Log bucket for Cloudfront"
}

variable "tags" {
  type        = "map"
  description = "Tags to assign to all resources"
}

variable "build_types" {
  type        = "list"
  description = "Build types to perform build, test and deploy"
}

variable "codebuild_image" {
  description = "AWS CodeBuild Image to use for CodeBuild Project"
}

variable "codepipeline_bucket" {
  description = "S3 bucket to hold codepipeline artifacts"
}

variable "app_name" {
  description = "Name of application"
}

variable "github_account" {
  description = "Github account name"
}

variable "github_repo" {
  description = "Github repository name"
}

variable "github_branch" {
  description = "Branch to pull source code from"
}

variable "github_oauth_token" {
  description = "Github OAuth token"
}

variable "aws_region" {
  description = "AWS region to deploy the app"
}

variable "codebuild_cache_s3" {
  description = "codebuild cache path in bucket-name/prefix format"
}

variable "app_directory" {
  description = "App directory in source code"
}
