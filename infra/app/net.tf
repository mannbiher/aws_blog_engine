resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Cloudfront Identity for blogging engine"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.origin_bucket.bucket_regional_domain_name}"
    origin_id   = "${var.cf_origin_id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.webapp_desc}"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.log_bucket.bucket_domain_name}"
    prefix          = "${var.domain_name}"
  }

  aliases = ["www.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.cf_origin_id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = "${var.tags}"

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate_validation.cert.certificate_arn}"
    ssl_support_method  = "sni-only"
  }
}

data "aws_route53_zone" "zone" {
  name         = "${var.domain_name}."
  private_zone = false
}

# Create Alias record to point to Cloudfront IPv4 and IPv6
resource "aws_route53_record" "zone_apex" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.domain_name}"
  type    = "A"

  alias {
    name = "${aws_cloudfront_distribution.s3_distribution.domain_name}"

    # alias for the zone ID Z2FDTNDATAQYW2.
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = "false"
  }
}

resource "aws_route53_record" "zone_apex_ipv6" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.domain_name}"
  type    = "AAAA"

  alias {
    name = "${aws_cloudfront_distribution.s3_distribution.domain_name}"

    # alias for the zone ID Z2FDTNDATAQYW2.
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = "false"
  }
}

# Create CNAME record for www.{your_domain}
resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "$www.{var.domain_name}"
  type    = "A"

  alias {
    name = "${aws_cloudfront_distribution.s3_distribution.domain_name}"

    # alias for the zone ID Z2FDTNDATAQYW2.
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = "false"
  }
}

resource "aws_route53_record" "www_ipv6" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "$www.{var.domain_name}"
  type    = "AAAA"

  alias {
    name = "${aws_cloudfront_distribution.s3_distribution.domain_name}"

    # alias for the zone ID Z2FDTNDATAQYW2.
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = "false"
  }
}
