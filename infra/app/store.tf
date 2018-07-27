data "aws_canonical_user_id" "current" {}

data "template_file" "bucket_policy" {
  template = "${file("${path.module}/origin_s3_policy.json")}"

  vars = {
    account_canonical_user = "${data.aws_canonical_user_id.current.id}"
    s3_bucket_arn          = "${aws_s3_bucket.origin_bucket.arn}"
  }
}

# CF origin s3 bucket
resource "aws_s3_bucket" "origin_bucket" {
  bucket = "${var.s3_origin_bucket}"

  # Below are required as terraform tries to change this property to default
  # if not specified
  acl = ""
}

# Setup lifecycle policy for logs 30 days
# 
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.s3_log_bucket}"

  acl = ""

  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_policy" "allow_cf_access" {
  bucket = "${aws_s3_bucket.origin_bucket.id}"
  policy = "${data.template_file.bucket_policy.rendered}"
}
