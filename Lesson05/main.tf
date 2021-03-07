provider "aws" {
  region = "us-west-2"
}

module "my_lambda_1" {
  source = "./tf_learning_lambda"
  lambda_name = "lesson-5-lambda-1"
  lambda_role = aws_iam_role.my_lambda_role.arn
  lambda_zipfile = "lambda.zip"
}