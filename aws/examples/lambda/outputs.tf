
output "archive" {
  value = {
    source   = data.archive_file.lambda.source_dir
    out-file = data.archive_file.lambda.output_path
  }
}

output "role" {
  value = aws_iam_role.lambda.arn
}

output "cloudwatch" {
  value = aws_cloudwatch_log_group.lambda.arn
}

output "lambda" {
  value = {
    arn        = aws_lambda_function.lambda.arn
    entrypoint = aws_lambda_function.lambda.handler
    id         = aws_lambda_function.lambda.id
    role       = aws_lambda_function.lambda.role
    runtime    = aws_lambda_function.lambda.runtime
  }
}
