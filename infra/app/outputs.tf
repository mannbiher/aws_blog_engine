output "codepipeline_name" {
  value = "${aws_codepipeline.app_pipeline.id}"
}

# output "codepipeline_version" {
#   value = "${aws_codepipeline.app_pipeline.version}"
# }

output "api_cert_arn" {
  value = "${aws_acm_certificate.api_cert.arn}"
}

output "dynamo_arn" {
  value = "${aws_dynamodb_table.app-table.arn}"
}

output "lambda_arn" {
  value = "${aws_lambda_function.test_lambda.arn}"
}