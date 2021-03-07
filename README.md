# A quick lesson in Terraform
This repo is designed for my talk at Tech Symposium 2021 at Cal Poly Pomona. It's a quick primer on how to use Terraform, with examples on how you'd use it to manage an AWS Lambda function.

This course will take you from creating your first resource to the basics of Terraform modules.

## Why do we care about Terraform?
Terraform excels at one thing - Letting you apply all the nice features you get from your VCS (git/github) to your infrastructure management - which is why it's called "Infrastructure as Code!" This means that you can gain all the following features:
* Reverts (really nice when you make a breaking change)
* History
* PR's and Approvals
* Testing
* and more! There's a lot of cool stuff folks have hooked into GitHub

## Do I need to know how to code to use Terraform?
Coding knowledge will help you recognize some patterns, but this isn't much harder than managing an Excel spreadsheet.
Like Excel, this can be made incredibly complex and powerful by it's power users (which is intimidating!) but that shouldn't stop less advanced users from using it.