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
