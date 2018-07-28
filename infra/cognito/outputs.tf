output "cognito_user_pool_id" {
  value = "${aws_cognito_user_pool.pool.id}"
}

output "cognito_user_pool_endpoint" {
  value = "${aws_cognito_user_pool.pool.endpoint}"
}

output "cognito_app_client_id" {
  value = "${aws_cognito_user_pool_client.client.id}"
}

output "cognito_identity_id" {
  value = "${aws_cognito_identity_pool.main.id}"
}
