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