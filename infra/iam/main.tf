provider "aws" {
  region = "${var.aws_region}"
}

data "aws_caller_identity" "current" {}

# Using templates so that role policy can be further restricted
data "template_file" "pipeline_policy" {
  template = "${file("${path.module}/codepipeline_role.json")}"
}

data "template_file" "codebuild_policy" {
  template = "${file("${path.module}/codebuild_role.json")}"
}

data "template_file" "lambda_policy" {
  template = "${file("${path.module}/lambda_policy.json")}"

  vars = {
    s3_origin_bucket = "${var.s3_origin_bucket}"
    region           = "${var.aws_region}"
    table            = "${var.app_name}"
    account_id       = "${data.aws_caller_identity.current.account_id}"
  }
}

# IAM role for codepipeline
resource "aws_iam_role" "pipeline_role" {
  name               = "${var.app_name}_pipeline_role"
  assume_role_policy = "${file("${path.module}/codepipeline_trust.json")}"
}

resource "aws_iam_role_policy" "pipeline_policy" {
  name = "pipeline_policy"
  role = "${aws_iam_role.pipeline_role.id}"

  policy = "${data.template_file.pipeline_policy.rendered}"
}

# IAM role for codebuild
resource "aws_iam_role" "codebuild_role" {
  name               = "${var.app_name}_codebuild_role"
  assume_role_policy = "${file("${path.module}/codebuild_trust.json")}"
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild_policy"
  role = "${aws_iam_role.codebuild_role.id}"

  policy = "${data.template_file.codebuild_policy.rendered}"
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "${var.app_name}_lambda_role"
  assume_role_policy = "${file("${path.module}/lambda_trust.json")}"
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = "${aws_iam_role.lambda_role.id}"

  policy = "${data.template_file.lambda_policy.rendered}"
}

