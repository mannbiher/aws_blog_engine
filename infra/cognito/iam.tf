data "terraform_remote_state" "api" {
  backend = "s3"
  config ={
    bucket  = "m-terraform-state"
    key     = "aws_blog_engine/api/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "template_file" "identity_trust" {
  template = "${file("${path.module}/identity_trust.json")}"

  vars = {
    identity_pool_id = "${aws_cognito_identity_pool.main.id}"
  }
}



data "template_file" "api_policy" {
  template = "${file("${path.module}/identity_api_policy.json")}"

  vars = {
    execution_arn = "${data.terraform_remote_state.api.execution_arn}"
  }
}

resource "aws_iam_role" "authenticated" {
  name               = "${var.app_name}_cognito_authenticated"
  assume_role_policy = "${data.template_file.identity_trust.rendered}"
}

resource "aws_iam_role_policy" "authenticated_default" {
  name   = "default_authenticated_policy"
  role   = "${aws_iam_role.authenticated.id}"
  policy = "${file("${path.module}/identity_cognito_policy.json")}"
}

resource "aws_iam_role_policy" "authenticated_api" {
  name   = "api_access"
  role   = "${aws_iam_role.authenticated.id}"
  policy = "${data.template_file.api_policy.rendered}"
}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = "${aws_cognito_identity_pool.main.id}"

  #   role_mapping {
  #     identity_provider         = "graph.facebook.com"
  #     ambiguous_role_resolution = "AuthenticatedRole"
  #     type                      = "Rules"


  #     mapping_rule {
  #       claim      = "isAdmin"
  #       match_type = "Equals"
  #       role_arn   = "${aws_iam_role.authenticated.arn}"
  #       value      = "paid"
  #     }
  #   }

  roles {
    "authenticated" = "${aws_iam_role.authenticated.arn}"
  }
}
