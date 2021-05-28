output "Master-Node-Public-IP" { # free form label for the output
  value = aws_instance.master-instance.public_ip
}

# This output block will iterate over all Oregon Instances and fetch each IP
output "Worker-Node-Public-IPs" {
  value = {
    for instance in aws_instance.worker-instance-oregon : # https://www.terraform.io/docs/language/expressions/for.html
    instance.id => instance.public_ip                     # https://www.terraform.io/docs/language/expressions/for.html#result-types
  }
}

#Add LB DNS name to outputs.tf
output "LB-DNS-NAME" {
  value = aws_lb.application-lb.dns_name
}