provider "aws" {
  region = "${var.aws_region}"
}

# Using templates so that role policy can be further restricted
data "template_file" "pipeline_policy" {
  template = "${file("${path.module}/codepipeline_role.json")}"
}

data "template_file" "codebuild_policy" {
  template = "${file("${path.module}/codebuild_role.json")}"
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
