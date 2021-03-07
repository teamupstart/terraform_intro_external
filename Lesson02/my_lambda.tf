resource "aws_lambda_function" "my_tf_lambda" {
  filename      = "lambda.zip"
  function_name = "my_terraform_lambda_function"
  role          = "<ARN FROM EARLIER>"
  handler = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256("lambda.zip")

  runtime = "python3.8"
}