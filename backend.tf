terraform {

  required_version = ">= 0.14.9"

  backend "s3" {
    region  = "eu-west-2"
    profile = "default"
    key     = "terraform-state-file"
    bucket  = "tf-state-052021"
  }
}

# % terraform init

# Initializing the backend...

# Successfully configured the backend "s3"! Terraform will automatically
# use this backend unless the backend configuration changes.