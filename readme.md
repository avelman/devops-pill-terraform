# DevOps Pill: Terraform
## Get [Terraform](https://www.terraform.io/downloads.html)

## Download AWS Cli
    curl -k "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

## Run AWS Configure
    aws configure

## Create a S3 bucket for State if not already present
    aws s3 mb s3://tf-state-devopspill

_In case of Firewall, mind to add_
`--no-verify-ssl`
