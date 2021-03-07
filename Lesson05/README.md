# Lesson 05
Modules

We learned how to set variables, and they don't seem too useful... until we get to modules. By the end of this lesson we should be building multiple lambdas with the same code, but different names (and could be different environment variables).

## Setting Up
Copy over everything from Lesson 04, and create a new `tf_learning_lambda/` folder.

## Setting up the module directory
Remember - Module == Directory! They're the same thing essentially, and you want to load things in.
Let's create only 3 files in the modules directory - `variables.tf`, `versions.tf`, and `main.tf`. For versions, copy that from the current directory. For the variables let's do the following in `variables.tf`:
```hcl
variable "lambda_role" {
    type = string
    description = "Lambda Role"
}

variable "lambda_name" {
    type = string
    description = "Name for the Lambda Function"
}
variable "lambda_zipfile" {
    type = string
    description = "Path to the lambda's zipfile."
}
```
Notice that it's the _lambda_ role now, not the account execution policy. We've also removed the default for the lambda_name, we don't want any.

And in `main.tf` let's steal our lambda from `my_lambda.tf` and replace its role with a variable:
```hcl
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
```
Note that we also brought our provider in - even though it's declared at the top, we want to declare it within each module's (directory's) `main.tf`

## Calling the module
Let's edit `my_lambda.tf` and remove our old lambda - wouldn't want that getting in the way! We can also remove:
```hcl
variable "lambda_name" {
    type = string
}
```
From the `variables.tf`

Let's call the lambda from `main.tf` by adding this block:
```hcl
module "my_lambda_1" {
  source = "./tf_learning_lambda"
  lambda_name = "lesson-5-lambda-1"
  lambda_role = aws_iam_role.my_lambda_role.arn
  lambda_zipfile = "lambda.zip"
}
```

## Buidling it
Alright! Let's do a `terraform plan`. You should get the new creates including a resource called: `module.my_lambda_1.aws_lambda_function.my_tf_lambda`

Notice this new path! 
1. `module` is that we're calling a module
2. `my_lambda_1` is the name of our module (that we put in `main.tf`)
3. `aws_lambda_function.my_tf_lambda` is the name of the resource within the module

And a `terraform apply` should have no issue building this.


## Calling it again
Now we want a second lambda, just like the first but with a different name. Let's do that by adding:
```hcl
module "my_lambda_2" {
  source = "./tf_learning_lambda"
  lambda_name = "lesson-5-lambda-2"
  lambda_role = aws_iam_role.my_lambda_role.arn
  lambda_zipfile = "lambda.zip"
}
```
to `main.tf` and doing another `terraform plan` and `terraform apply` - you should see it created!

## Afterwords
This may seem like extra effort when you're only creating one resource - but imagine you're creating a whole package of things - like the lambda's role, networking, secrets, and more - this can be a lot more powerful.