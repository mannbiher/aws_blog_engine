variable "app_name" {
  description = "Name of application"
  default     = "blog-on-aws"
}

variable "aws_region" {
  default = "us-east-1"
}
variable "s3_origin_bucket" {
  description = "S3 bucket domain for cloudfront origin"
}

variable "lambda_basic_execution_managed_policy_arn" {
  default     = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  description = "Access to write cloudwatch logs"
}
