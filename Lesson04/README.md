# Lesson 04
Variables

Reference: https://www.terraform.io/docs/language/values/variables.html

In this lesson, we're gonna chat about variables you can use in Terraform, and why they're helpful. 

## Goal
Same resource from Lesson 3 - we'll be abstracting the execution policy and the Lambda's name to variables

## Setting up
After you've copied everything from Lesson 3, let's create a `variables.tf` with the following in it:
```hcl
variable "lambda_execution_policy" {
    type = string
    description = "Account Execution Policy"
}

variable "lambda_name" {
    type = string
    description = "Account Execution Policy"
    default = "Lesson4_lambda_name"
}
```

## Setting the variables
Let's do a `terraform init` and a `terraform plan` - It should prompt you for the value for that variable! You'll notice you don't get prompted for the lambda name because you called a default.

You can also pre-load the variable with a .tfvars file (passed to the `terraform` command with -var-file) or you can have `<name>.auto.tfvars` to load them in! For now, let's stick to calling it on the command line.

`terraform plan -var="lambda_execution_policy=<arn_from_lesson_3>"`

This should work! But we're not using the variables.

## Using the variables
So let's edit `my_lambda.tf` and replace the areas that we want to use. This means you should have a `my_lambda.tf` that looks like:
```hcl
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
```

Play around with terraform plan and apply to see how you can get them to change! You can also try setting things with `<x>.tfvars` and `<x>.auto.tfvars` files, and the environment settings descirbed in https://www.terraform.io/docs/language/values/variables.html