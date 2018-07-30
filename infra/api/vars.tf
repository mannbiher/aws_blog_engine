variable "app_name" {
  description = "Name of application"
  default     = "blog-on-aws"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "domain_name" {
  description = "Naked domain name of your website"
}
