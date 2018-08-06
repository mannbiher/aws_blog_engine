resource "aws_dynamodb_table" "app-table" {
  name           = "${var.app_name}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "author_id"

  attribute {
    name = "author_id"
    type = "S"
  }

  tags = "${var.tags}"

}