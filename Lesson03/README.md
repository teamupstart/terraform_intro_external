# Lesson 3
Creating resources that talk to each other

## Pre-Setup
Copy over all your .tf and lambda files from Lesson02, we'll be starting from there.

## Getting the managed role policy name
You could craft your basic lambda execution role by hand, but it's better to grab it out of your account. 
Search in the IAM roles to get something that looks like:

`arn:aws:iam::\<account_id\>:policy/service-role/AWSLambdaBasicExecutionRole-\<GUID\>`

## Creating the role
We need to create a role now to be used. We're going to use that policy to attach it to our new role. 
We can add this to the bottom of `my_lambda.tf` and the body will look like:
```hcl
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
    "<Execution Role>",
  ]
}
```

## Attaching the role to the Lambda
Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function

Now we want to attach it to the lambda - this is pretty simple! We reference it, and change:
```
  role          = "<ARN FROM EARLIER>"
```
to be
```
  role          = aws_iam_role.my_lambda_role.arn
```

Now when we do terraform apply, it should create both the lambda and the role! (ensure you destroyed the last step though!)