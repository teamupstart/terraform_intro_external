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