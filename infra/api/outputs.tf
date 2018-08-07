output "execution_arn" {
  value = "${aws_api_gateway_deployment.api.execution_arn}"
}

output "api_id" {
  value = "${aws_api_gateway_rest_api.api.id}"
}
