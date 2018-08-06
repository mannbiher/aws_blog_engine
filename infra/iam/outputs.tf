output "codebuild_iam_role" {
  value = "${aws_iam_role.codebuild_role.arn}"
}

output "codepipeline_iam_role" {
  value = "${aws_iam_role.pipeline_role.arn}"
}

output "lambda_iam_role" {
  value = "${aws_iam_role.lambda_role.arn}"
}
