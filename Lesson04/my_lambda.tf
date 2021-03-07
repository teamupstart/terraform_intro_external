resource "aws_lambda_function" "my_tf_lambda" {
  filename      = "lambda.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.my_lambda_role.arn
  handler = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256("lambda.zip")
  publish = null
  runtime = "python3.8"
}

resource "aws_iam_role" "my_lambda_role" {
  assume_role_policy =  jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  path = "/service-role/"
  managed_policy_arns = [
    var.lambda_execution_policy,
  ]
}