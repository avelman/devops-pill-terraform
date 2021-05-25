# First provider AWS for the 'Master' region
provider "aws" {
  profile = var.profile
  region  = var.region-master
  alias   = "region-master"
}

# Second provider AWS for the 'Worker' region
provider "aws" {
  profile = var.profile
  region  = var.region-worker
  alias   = "region-worker"
}