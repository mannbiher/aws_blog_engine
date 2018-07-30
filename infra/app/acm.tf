# Request an ACM certificate for Cloudfront
# Region should be us-east-1 for CloudFront certificate
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

resource "aws_acm_certificate" "cert" {
  provider                  = "aws.virginia"
  domain_name               = "${var.domain_name}"
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"

  tags = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

# Route 53 zone is defined in net.tf
resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_alt1" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.cert_validation.fqdn}",
    "${aws_route53_record.cert_validation_alt1.fqdn}",
  ]
}

resource "aws_acm_certificate" "api_cert" {
  provider    = "aws.virginia"
  domain_name = "api.${var.domain_name}"

  #subject_alternative_names = ["www.${var.domain_name}"]
  validation_method = "DNS"

  tags = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "api_cert_validation" {
  name    = "${aws_acm_certificate.api_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.api_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.api_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "api_cert" {
  certificate_arn = "${aws_acm_certificate.api_cert.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.api_cert_validation.fqdn}",
  ]
}
