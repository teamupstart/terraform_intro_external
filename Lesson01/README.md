# Lesson 1: Setup
The stuff everyone forgets to tell you.

## Tool Version Control
Not all your TerraForm code will be in the same version - Use a version manager so you can control versions per repo. I recommend ASDF, which uses `.tool-versions` in the folder

## Resource Control
Terraform only controls the Resources it's configured to - you can't say "Put all Lambda functions in Terraform" - but you can say "These lambda functions are controlled by terraform"

## Organization of files in a repo
File separation doesn't matter in Terraform. Directory separation does - a lot.

A directory in terraform is considered a "module" - and the one you run the terraform commands in is the "root module."

There _are_ certain conventions people follow though.

* `main.tf` - this should be your core file with all the imporatant core information - like the provider
* `versions.tf` - Terraform will create and somewhat manage this - this is where you control your provider versions
* `terraform.tfstate` - The local statefile, used by default if you don't configure remote state. JSON blob, take a look inside but don't touch unless you've made a good backup!

## Basic Terraform Commands
* `terraform init` -> Set up the provider (we'll do this in Lesson 1) and get ready to start managing resources
* `terraform plan` -> Check the current state of all resources under terraform's control, and determine if changes are necessary to make the repo configuration reality
* `terraform apply` -> Make the changes (which would be shown by a plan) to make the repo configuration reality
* `terraform destroy` -> "I'm done!" - this command destroys all the production resources in control by the current terraform statefile

## Extra wins
I always set up my gitignore based on GitHub's recommendations: https://github.com/github/gitignore/blob/master/Terraform.gitignore
