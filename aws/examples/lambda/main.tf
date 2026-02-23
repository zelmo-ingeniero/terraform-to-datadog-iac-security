
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/code.zip"
}

variable "function-name" {
  type = string
  validation {
    condition     = length(var.function-name) > 1 && length(var.function-name) < 64
    error_message = "function name is too long or too short"
  }
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.function-name
  role             = aws_iam_role.lambda.arn
  filename         = "${path.module}/code.zip"
  handler          = "index.hanler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  depends_on       = [aws_cloudwatch_log_group.lambda]
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function-name}"
  retention_in_days = 1
}
