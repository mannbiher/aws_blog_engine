output "codepipeline_name" {
  value = "${aws_codepipeline.app_pipeline.id}"
}

# output "codepipeline_version" {
#   value = "${aws_codepipeline.app_pipeline.version}"
# }

output "api_cert_arn" {
  value = "${aws_acm_certificate.api_cert.arn}"
}
