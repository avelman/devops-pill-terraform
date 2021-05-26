terraform {

  required_version = ">= 0.14.9"

  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "terraform-state-file-pill"
    bucket  = "tf-state-devopspill"
  }
}

# % terraform init

# Initializing the backend...

# Successfully configured the backend "s3"! Terraform will automatically
# use this backend unless the backend configuration changes.