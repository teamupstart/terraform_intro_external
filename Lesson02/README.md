# Lesson 2
Creating your first resource

## Pre-Setup
Go into AWS and create a lambda function - follow all the basic instructions. This should result in you having a role that's ready to associate with another lambda - write it down! We will be using that for this lesson, and creating it in future lessons.

## Setting up your environment
https://registry.terraform.io/providers/hashicorp/aws/latest/docs

We need to set up the provider first, so we'll put this in `versions.tf`:
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
```
and this in `main.tf` (feel free to change the region):
```hcl
provider "aws" {
  region = "us-east-1"
}
```

then, for testing, we'll create a .AWS_TOKENS.env with hardcoded values:
```
export AWS_ACCESS_KEY_ID="<YOUR ACCESS KEY HERE>"
export AWS_SECRET_ACCESS_KEY="<YOUR SECRET KEY HERE>"
```
or you can set it up with your awscli profile if you have one (instructions are in the link)
I also recommend doing:
```
export AWS_REGION="us-east-1"
```
so we don't have to go hunting for the function you create.

Now that we've set it up, we need to run:
```sh
terraform init
```

## Setting up your lambda
To run your lambda, we'll need some code! Check out the `code/` subfolder for an example lambda, but you can do any python3.8 one here!

We need to zip it up - so let's do this manually (at least for now)
```sh
cd code && zip -r ../lambda.zip *.py && cd ..
```

And then we can declare the resource - let's make a `my_lambdas.tf` to do it in! Remember - we need to use that role ARN from earlier!

```hcl
resource "aws_lambda_function" "my_tf_lambda" {
  filename      = "lambda.zip"
  function_name = "my_terraform_lambda_function"
  role          = "<ARN FROM EARLIER>"
  handler       = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256("lambda.zip")

  runtime = "python3.8"
}

```
based on: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function

## Creating!
The fun part! Let's create that function on AWS!
We can check the output first with `terraform plan` - but then we want to build! So let's do
```sh
terraform apply
```

Which should look like:
```sh

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_lambda_function.my_tf_lambda will be created
  + resource "aws_lambda_function" "my_tf_lambda" {
      + arn                            = (known after apply)
      + filename                       = "lambda.zip"
      + function_name                  = "my_terraform_lambda_function"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + package_type                   = "Zip"
      + publish                        = false
      + qualified_arn                  = (known after apply)
      + reserved_concurrent_executions = -1
      + role                           = "<${YOUR_ARN_FROM_EARLIER}>"
      + runtime                        = "python3.8"
      + signing_job_arn                = (known after apply)
      + signing_profile_version_arn    = (known after apply)
      + source_code_hash               = "cDv4bktU+2nIGZAx1ZoLu2FdceJRtuo9t+rEIQOC43g="
      + source_code_size               = (known after apply)
      + timeout                        = 3
      + version                        = (known after apply)

      + tracing_config {
          + mode = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```

Type in `yes`, and check out your AWS account - You should have a new lambda!

## Important things to note:
1. See how it's called `aws_lambda_function.my_tf_lambda`?
   This is the Terraform Resource name - not pushed to AWS, but how Terraform keeps track of the resource for its own state management.
2. Did you see all that `(known after apply)` stuff? That's stuff that _will_ be stored in the state after create.
