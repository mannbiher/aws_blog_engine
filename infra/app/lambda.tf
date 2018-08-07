data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "test_lambda" {
  filename         = "dummy_lambda.zip"
  function_name    = "dummy_lambda_name"
  role             = "${data.terraform_remote_state.iam.lambda_iam_role}"
  handler          = "index.handler"
  source_code_hash = "${base64sha256(file("dummy_lambda.zip"))}"
  runtime          = "nodejs8.10"

  tags = "${var.tags}"

}


# Refactor your authentication
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  # source_arn = "${data.terraform_remote_state.api.execution_arn}/POST/blogs"
  source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${data.terraform_remote_state.api.api_id}/*/POST/blogs"
}