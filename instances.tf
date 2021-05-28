# The following data resources will execute an API Call to AWS SSM, fetching information for the AMI available on each region; and add it into the State file which is placed in the backend (S3 bucket)

# Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Get Linux AMI ID using SSM Parameter endpoint in us-west-2
data "aws_ssm_parameter" "linuxAmiOregon" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Please note that this code expects SSH key pair to exist in default dir under 
#users home directory, otherwise it will fail

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "ssh-key"
  public_key = file("./ssh/aws-key.pub")
}

#Create key-pair for logging into EC2 in us-west-2
resource "aws_key_pair" "worker-key" {
  provider   = aws.region-worker
  key_name   = "ssh-key"
  public_key = file("./ssh/aws-key.pub")
}

################################################
#               EC2 Instances
################################################

# Create and bootstrap EC2 in us-east-1
resource "aws_instance" "master-instance" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.master-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id

  tags = {
    Name = "master_instance_tf"
  }

  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]

  user_data = <<-EOF
      #!/bin/bash
      sudo amazon-linux-extras enable nginx1.12
      sudo yum -y install nginx
      sudo systemctl start nginx
      EOF

  # provisioner "remote-exec" { # https://www.terraform.io/docs/language/resources/provisioners/remote-exec.html
  #   inline = [
  #     "sudo amazon-linux-extras enable nginx1.12",
  #     "sudo yum -y install nginx",
  #     "sudo systemctl start nginx",
  #   ]

  # }
  # connection {
  #   type = "ssh"
  #   user = "ec2-user"
  #   #password = ""
  #   host        = self.public_ip # https://www.terraform.io/docs/language/resources/provisioners/connection.html
  #   private_key = file("./ssh/aws-key")
  # }
}

# Create EC2 in us-west-2
resource "aws_instance" "worker-instance-oregon" {
  provider                    = aws.region-worker
  count                       = var.workers-count # https://www.terraform.io/docs/language/meta-arguments/count.html#basic-syntax
  ami                         = data.aws_ssm_parameter.linuxAmiOregon.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.worker-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.worker-sg-oregon.id]
  subnet_id                   = aws_subnet.subnet_1_oregon.id

  tags = {
    Name = join("_", ["master_instance_tf", count.index + 1]) # https://www.terraform.io/docs/language/functions/join.html
  }
  depends_on = [aws_main_route_table_association.set-worker-default-rt-assoc, aws_instance.master-instance] # Other dependencies
}