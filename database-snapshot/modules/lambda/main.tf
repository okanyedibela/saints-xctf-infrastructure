/**
 * Infrastructure for the saintsxctf RDS database snapshot lambda function
 * Author: Andrew Jarombek
 * Date: 6/7/2019
 */

locals {
  env = var.prod ? "prod" : "dev"
}

data "archive_file" "lambda" {
  source_file = "lambda.py"
  output_path = "dist/lambda-${local.env}.zip"
  type = "zip"
}

resource "aws_lambda_function" "rds-snapshot-lambda-function" {
  function_name = "${upper(local.env)}SaintsXCTFSnapshot"
  filename = "lambda-${local.env}.zip"
  handler = "lambda.take_snapshot"
  role = aws_iam_role.lambda-role.arn
  runtime = "python3.7"
  source_code_hash = base64sha256(file(data.archive_file.lambda.output_path))

  tags {
    Name = "saints-xctf-rds-${local.env}-snapshot"
    Environment = upper(local.env)
    Application = "saints-xctf"
  }
}

resource "aws_iam_role" "lambda-role" {
  name = "saints-xctf-rds-snapshot-lambda-role"
  assume_role_policy = file("${path.module}/role.json")

  tags {
    Name = "saints-xctf-rds-snapshot-lambda-role"
    Environment = "all"
    Application = "saints-xctf"
  }
}

resource "aws_cloudwatch_event_rule" "lambda-function-schedule-rule" {
  name = "saints-xctf-rds-${local.env}-snapshot-lambda-rule"
  description = "Execute the Lambda Function Daily"
  schedule_expression = "rate(5 minutes)" # "cron(0 7 * * * *)"
  is_enabled = true

  tags {
    Name = "saints-xctf-rds-${local.env}-snapshot-lambda-rule"
    Environment = upper(local.env)
    Application = "saints-xctf"
  }
}

resource "aws_cloudwatch_event_target" "lambda-function-schedule-target" {
  arn = aws_lambda_function.rds-snapshot-lambda-function.arn
  rule = aws_cloudwatch_event_rule.lambda-function-schedule-rule.name
}