provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "app" {
  backend = "s3"

  config {
    bucket = "m-terraform-state"
    key    = "aws_blog_engine/app/terraform.tfstate"
    region = "us-east-1"
  }
}

data "template_file" "swagger_def" {
  template = "${file("${path.module}/swagger.json")}"

  vars {
    app_name = "${var.app_name}"
  }
}

data "aws_route53_zone" "zone" {
  name         = "${var.domain_name}."
  private_zone = false
}

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.app_name}-api"

  body = "${data.template_file.swagger_def.rendered}"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name     = "api.${var.domain_name}"
  certificate_arn = "${data.terraform_remote_state.app.api_cert_arn}"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "api_domain_ipv4" {
  zone_id = "${data.aws_route53_zone.zone.id}" # See aws_route53_zone for how to create this

  name = "${aws_api_gateway_domain_name.custom_domain.domain_name}"
  type = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.custom_domain.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.custom_domain.cloudfront_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api_domain_ipv6" {
  zone_id = "${data.aws_route53_zone.zone.id}" # See aws_route53_zone for how to create this

  name = "${aws_api_gateway_domain_name.custom_domain.domain_name}"
  type = "AAAA"

  alias {
    name                   = "${aws_api_gateway_domain_name.custom_domain.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.custom_domain.cloudfront_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_api_gateway_deployment" "api" {
  # See aws_api_gateway_rest_api_docs for how to create this
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "live"
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_deployment.api.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.custom_domain.domain_name}"
}
