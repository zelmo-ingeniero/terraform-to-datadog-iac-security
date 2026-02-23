
# data "aws_iam_policy_document" "assume-role" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#   }
# }

# data "aws_iam_policy_document" "s3-cloudwatch" {
#   statement {
#     effect    = "Allow"
#     actions   = ["s3:PutObject", "s3:GetObject"]
#     resources = ["arn:aws:s3:::remote-tfbackend-infra"]
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents"
#     ]
#     resources = ["arn:aws:logs:*:*:*"]
#   }
# }

resource "aws_iam_role" "lambda" {
  name = "lambda-s3-putobject"
  inline_policy {
    name   = "enable-s3-policy"
    policy = file("${path.module}/lambda_s3_cloudwatch_role.json")
  }
  assume_role_policy = file("${path.module}/lambda_service_role.json")
}
