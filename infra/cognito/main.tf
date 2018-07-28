provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_cognito_user_pool" "pool" {
  name                = "${var.app_name}-cognito-pool"
  username_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${var.app_name}-client"

  user_pool_id                 = "${aws_cognito_user_pool.pool.id}"
  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "${var.app_name_alphanumeric} Identity Pool"
  allow_unauthenticated_identities = false

  # TODO create multi-region cognito user pools  
  cognito_identity_providers {
    client_id               = "${aws_cognito_user_pool_client.client.id}"
    provider_name           = "${aws_cognito_user_pool.pool.endpoint}"
    server_side_token_check = false
  }

  # TODO support social logins
  #   supported_login_providers {
  #     "graph.facebook.com"  = "7346241598935552"
  #     "accounts.google.com" = "123456789012.apps.googleusercontent.com"
  #   }
}
