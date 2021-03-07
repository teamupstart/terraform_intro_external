provider "aws" {
  region = "us-west-2"
}

resource "aws_lambda_function" "my_tf_lambda" {
  filename      = var.lambda_zipfile
  function_name = var.lambda_name
  role          = var.lambda_role
  handler = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256(var.lambda_zipfile)
  publish = null
  runtime = "python3.8"
}
